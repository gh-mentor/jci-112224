"""
This app uses Python 3.14, numpy, pandas, matplotlib to generate a set of data points and plot them on a graph.
"""

# import the necessary libraries
import numpy as np                  # this library is used to generate the data points
import pandas as pd                 # this library is used to store the data points in a dataframe
import matplotlib.pyplot as plt     # this library is used to plot the data points on a graph

"""
Create a function 'gendatapoints' that generates a set of 100 data points (x, f(x)) and returns them as a pandas data frame.
Arguments:
- 'x_range' is a tuple of two integers representing the rang0 e of x values to generate.
Returns:
- A pandas data frame with two columns, 'x' and 'y'.
Details:
- 'x' values are generated randomly between x_range[0] and x_range[1].
- 'y' values are generated as a non-linear function of x with excessive random noise: y = x ^ 1.5  + noise.
- The data frame is sorted by the 'x' values.
- The data frame has 100 rows.
Error Handling:
- Raise a ValueError if x_range is not a tuple of two integers.
- Raise a ValueError if x_range[0] is greater than x_range[1].
Exceptions:
- ValueError: "x_range must be a tuple of two integers."
- ValueError: "x_range[0] must be less than x_range[1]."
Examples:
- gendata((0, 100)) generates a data frame with 'x' values between 0 and 100.
- gendata((-100, 100)) generates a data frame with 'x' values between -100 and 100.
"""

def gendatapoints(x_range):
    """
    Generate a DataFrame of 100 data points based on a given range.

    Parameters:
    x_range (tuple): A tuple of two integers specifying the range (inclusive) 
                     within which to generate the x values. The first integer 
                     must be less than the second integer.

    Returns:
    pandas.DataFrame: A DataFrame with 100 rows and two columns 'x' and 'y'. 
                      The 'x' column contains integers generated within the 
                      specified range, and the 'y' column contains values 
                      computed as x ** 1.5 plus some normally distributed noise.

    Raises:
    ValueError: If x_range is not a tuple of two integers or if the first 
                integer is not less than the second integer.
    """
    # check if x_range is a tuple of two integers
    if not isinstance(x_range, tuple) or len(x_range) != 2 or not all(isinstance(x, int) for x in x_range):
        raise ValueError("x_range must be a tuple of two integers.")
    # check if x_range[0] is less than x_range[1]
    if x_range[0] >= x_range[1]:
        raise ValueError("x_range[0] must be less than x_range[1].")
    # generate 100 data points
    x = np.random.randint(x_range[0], x_range[1], 100)
    noise = np.random.normal(0, 10, 100)
    y = x ** 1.5 + noise
    # create a pandas data frame
    df = pd.DataFrame({'x': x, 'y': y})
    df = df.sort_values(by='x')
    return df

"""
Create a function 'plot_data' that plots the data points from the data frame.
Arguments:
- 'data' is a pandas data frame with two columns, 'x' and 'y'.
Returns:
- None
Details:
- The data points are plotted as a scatter plot.
- The plot has a title 'Data Points', x-axis label 'x', and y-axis label 'f(x)'.
Error Handling:
- Raise a ValueError if data is not a pandas data frame.
Examples:
- plot_data(df) plots the data points from the data frame df.
"""

def plot_data(data):
    # check if data is a pandas data frame
    if not isinstance(data, pd.DataFrame):
        raise ValueError("data must be a pandas data frame.")
    # plot the data points
    plt.scatter(data['x'], data['y'])
    plt.title('Data Points')
    plt.xlabel('x')
    plt.ylabel('f(x)')
    plt.show()

"""
Create a function 'main' that generates a set of data points and plots them on a graph.
Arguments:
- None
Returns:
- None
"""

def main():
    # generate a set of data points
    data = gendatapoints((0, 100))
    # plot the data points
    plot_data(data)

# call the main function
if __name__ == '__main__':
    main()

