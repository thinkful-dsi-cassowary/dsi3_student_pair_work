import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import math

# ----- FUNCTION FOR DISTRIBUTIONS ---------------|
def auto_subplots(df, **kwargs):
    '''
    This function creates a series of sublots to display the distribution for all continuous variables in a DataFrame
    It operates like a FacetGrid, but it's a little more customized.

    The dimensions of the subplot (no_subplots X no_subplots) are calculated automatically by how many continuous variables are found.
    You can use a number of kwargs to customize the output of the function. Those include:
    kwargs:
        limitx  -   Limits the number of subplots along the x-axis, and calculates the no_subplots on y axis from given limit
        kind    -   Allows you to specify which type of distribution grid you'd like to use. Values include
            -   hist: creates a matplotlib.pyplot histogram
            -   boxplot: creates a seaborn boxplot
                -   whis: adjust the boxplot whisker bounds
            -   swarm: create a one-dimensional seaborn swarmplot

    Returns None

    '''
    EACH_SIZE = 3
    # WSPACE = .3
    # HSPACE = .7
    DEFAULT_BOXPLOT_WHIS = 1.5

    columns = df.select_dtypes(include='number').columns
    len_cols = len(columns)

    if kwargs.get('limitx'):
        limitx = kwargs.get('limitx')
        count_dimensions = tuple([limitx, int(len_cols/limitx + 1)])

    else:
        try_num = len_cols
        while True:
            sq = math.sqrt(try_num)
            if sq == int(sq):
                break
            try_num += 1
        count_dimensions = tuple([sq, sq])

    dimensions = tuple([count_dimensions[0] * EACH_SIZE, count_dimensions[1] * EACH_SIZE])
    plt.figure(figsize=dimensions)

    for i, col in enumerate(columns, 1):
        plt.subplot(count_dimensions[0], count_dimensions[1], i)
        if kwargs.get('kind'):
            kind = kwargs.get('kind')
            selection = ['hist', 'boxplot', 'swarm']
            if kind == 'hist':
                plt.hist(df[col])
            elif kind == 'boxplot':
                whis = DEFAULT_BOXPLOT_WHIS
                if kwargs.get('whis'):
                    whis = kwargs.get('whis')
                sns.boxplot(df[col], whis=whis)
            elif kind == 'swarm':
                sns.swarmplot(y=col, data=df)
            else:
                print('Kind: {} is currently unavailable. For now enjoy our limited selection of: {}'.format(kind, selection))
        else:
            plt.hist(df[col])
        plt.title(col)

    # plt.subplots_adjust(wspace=WSPACE, hspace=HSPACE)
    plt.tight_layout()
    plt.show()
# ------- END OF DISTRIBUTION SELF_MADE FUNCS ----------------------|

# ----- FUNCTION FOR GENERAL MISSING VALUES ---------------|
def missingness_summary(df, **kwargs):
    '''
    This function creates a series representing what percentage of data is null for each column of a dataframe

    You can use a number of kwargs to customize the function. Those include:
    kwargs:
        print_log   -   [True, False]: If true, will print the output before returning the Series (default False)
        sort        -   ['asc', 'desc']: Allows you to sort the data by ascending or descending (default 'desc')
    
    Returns Series with index = column names and value = percentage of nulls in column

    '''
    s = df.isna().sum()*100/len(df)

    sort = 'desc'
    if kwargs.get('sort'):
        sort = kwargs.get('sort')
    if sort == 'asc':
        s.sort_values(ascending=True, inplace=True)
    elif sort == 'desc':
        s.sort_values(ascending=False, inplace=True)

    print_log = False
    if kwargs.get('print_log'):
        print_log = kwargs.get('print_log')
    if print_log == True:
        print(s)

    return s
# ------- END OF MISSING SELF_MADE FUNCS ----------------------|

# ----- FUNCTIONS FOR GENERAL OUTLIER HANDLING --------------|
def get_minmax_with_threshold(s, threshold):
    q75, q25 = np.percentile(s, [75,25])
    iqr = q75 - q25
    min_val = q25 - (iqr*threshold)
    max_val = q75 + (iqr*threshold)
    
    return min_val, max_val
    
def get_outliers(s, threshold):
    min_val, max_val = get_minmax_with_threshold(s, threshold)
    return s.loc[(s > max_val) | (s < min_val)]

def outliers_summary(df, threshold, **kwargs):  
    '''
    This function creates a series representing what percentage of data are outliers for each column of a dataframe

    You can use a number of kwargs to customize the function. Those include:
    kwargs:
        print_log   -   [True, False]: If true, will print the output before returning the Series (default False)
        sort        -   ['asc', 'desc']: Allows you to sort the data by ascending or descending (default 'desc')
    
    Returns Series with index = column names and value = percentage of outliers in column

    '''
    s = pd.Series([get_outliers(df[col], threshold).count() *100 / len(df[col])
                   for col in df.select_dtypes(include='number').columns],
                 index=df.select_dtypes(include='number').columns)
    
    sort = 'desc'
    if kwargs.get('sort'):
        sort = kwargs.get('sort')
    if sort == 'asc':
        s.sort_values(ascending=True, inplace=True)
    elif sort == 'desc':
        s.sort_values(ascending=False, inplace=True)

    print_log = False
    if kwargs.get('print_log'):
        print_log = kwargs.get('print_log')
    if print_log == True:
        print(s)
        
    return s

def get_percentiles(df, column_name, threshold):
    min_val, max_val = get_minmax_with_threshold(df[column_name], threshold)
    
    max_percentile = df.loc[df[column_name] >= max_val, column_name].count() / len(df[column_name])
    min_percentile = df.loc[df[column_name] <= min_val, column_name].count() / len(df[column_name])
    
    return min_percentile, max_percentile
# ------- END OF OUTLIER SELF_MADE FUNCS ----------------------|

# ----- FUNCTIONS FOR ANALYZING MODELS --------------|
def plot_confusion_matrix(cm,
                          target_names,
                          title='Confusion matrix',
                          cmap=None,
                          normalize=True):
    """
    given a sklearn confusion matrix (cm), make a nice plot

    Arguments
    ---------
    cm:           confusion matrix from sklearn.metrics.confusion_matrix

    target_names: given classification classes such as [0, 1, 2]
                  the class names, for example: ['high', 'medium', 'low']

    title:        the text to display at the top of the matrix

    cmap:         the gradient of the values displayed from matplotlib.pyplot.cm
                  see http://matplotlib.org/examples/color/colormaps_reference.html
                  plt.get_cmap('jet') or plt.cm.Blues

    normalize:    If False, plot the raw numbers
                  If True, plot the proportions

    Usage
    -----
    plot_confusion_matrix(cm           = cm,                  # confusion matrix created by
                                                              # sklearn.metrics.confusion_matrix
                          normalize    = True,                # show proportions
                          target_names = y_labels_vals,       # list of names of the classes
                          title        = best_estimator_name) # title of graph

    Citiation
    ---------
    http://scikit-learn.org/stable/auto_examples/model_selection/plot_confusion_matrix.html

    """
    import matplotlib.pyplot as plt
    import numpy as np
    import itertools

    accuracy = np.trace(cm) / float(np.sum(cm))
    misclass = 1 - accuracy

    if cmap is None:
        cmap = plt.get_cmap('Blues')

    plt.figure(figsize=(8, 6))
    plt.imshow(cm, interpolation='nearest', cmap=cmap)
    plt.title(title)
    plt.colorbar()

    if target_names is not None:
        tick_marks = np.arange(len(target_names))
        plt.xticks(tick_marks, target_names, rotation=45)
        plt.yticks(tick_marks, target_names)

    if normalize:
        cm = cm.astype('float') / cm.sum(axis=1)[:, np.newaxis]


    thresh = cm.max() / 1.5 if normalize else cm.max() / 2
    for i, j in itertools.product(range(cm.shape[0]), range(cm.shape[1])):
        if normalize:
            plt.text(j, i, "{:0.4f}".format(cm[i, j]),
                     horizontalalignment="center",
                     color="white" if cm[i, j] > thresh else "black")
        else:
            plt.text(j, i, "{:,}".format(cm[i, j]),
                     horizontalalignment="center",
                     color="white" if cm[i, j] > thresh else "black")


    plt.tight_layout()
    plt.ylabel('Predicted label')
    plt.xlabel('True label\naccuracy={:0.4f}; misclass={:0.4f}'.format(accuracy, misclass))
    plt.show()
# ------- END OF MODEL ANALYSIS SELF_MADE FUNCS ----------------------|








# def auto_subplots(df, **kwargs):
#     '''
#     This function creates a series of sublots to display the distribution for all continuous variables in a DataFrame
#     It operates like a FacetGrid, but it's a little more customized.

#     The dimensions of the subplot (no_subplots X no_subplots) are calculated automatically by how many continuous variables are found.
#     You can use a number of kwargs to customize the output of the function. Those include:
#     kwargs:
#         limitx  -   Limits the number of subplots along the x-axis, and calculates the no_subplots on y axis from given limit
#         kind    -   Allows you to specify which type of distribution grid you'd like to use. Values include
#             -   hist: creates a matplotlib.pyplot histogram
#             -   boxplot: creates a seaborn boxplot
#                 -   whis: adjust the boxplot whisker bounds
#             -   swarm: create a one-dimensional seaborn swarmplot

#     Returns None

#     '''
#     EACH_SIZE = 3
#     WSPACE = .3
#     HSPACE = .7
#     DEFAULT_BOXPLOT_WHIS = 1.5

#     columns = df.select_dtypes(include='number').columns
#     len_cols = len(columns)

#     categories = df.select_dtypes(include='object').columns
#     len_cats = len(categories)

#     if kwargs.get('limitx'):
#         limitx = kwargs.get('limitx')
#         count_dimensions = tuple([limitx, int(len_cols/limitx + 1)])
#     else:
#         try_num = len_cols
#         while True:
#             sq = math.sqrt(try_num)
#             if sq == int(sq):
#                 break
#             try_num += 1
#         count_dimensions = tuple([sq, sq])

#     dimensions = tuple([count_dimensions[0] * EACH_SIZE, count_dimensions[1] * EACH_SIZE])
#     plt.figure(figsize=dimensions)

#     for category in categories:
#         for sub_cat in df[category].unique():
#             if not kwargs.get('categorical'):
#                 sub_cat = df[category].unique()

#             plot_df = df.loc[df[category].isin(pd.Series(sub_cat))]

#             for i, col in enumerate(columns, 1):
#                 plt.subplot(count_dimensions[0], count_dimensions[1], i)
#                 if kwargs.get('kind'):
#                     kind = kwargs.get('kind')
#                     selection = ['hist', 'boxplot', 'swarm']
#                     if kind == 'hist':
#                         plt.hist(plot_df[col])
#                     elif kind == 'boxplot':
#                         whis = DEFAULT_BOXPLOT_WHIS
#                         if kwargs.get('whis'):
#                             whis = kwargs.get('whis')
#                         sns.boxplot(plot_df[col], whis=whis)
#                     elif kind == 'swarm':
#                         sns.swarmplot(y=col, data=plot_df)
#                     else:
#                         print('Kind: {} is currently unavailable. For now enjoy our limited selection of: {}'.format(kind, selection))
#                 else:
#                     plt.hist(plot_df[col])
#             plt.title(col)
#         if not kwargs.get('categorical'):
#             break

#     # plt.subplots_adjust(wspace=WSPACE, hspace=HSPACE)
#     plt.tight_layout()
#     plt.show()

# auto_subplots(life_df, categorical=True)