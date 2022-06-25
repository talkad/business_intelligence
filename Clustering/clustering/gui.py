import tkinter.messagebox
from tkinter import *
from tkinter import Tk, Label, Button, Entry, W
from tkinter import filedialog

from classify import classify
from preprocessor import preprocessor


# calls a popup window with the provided message
def error_msg(msg):
    tkinter.messagebox.showinfo("K Means Clustering", msg)


class Gui:

    def __init__(self, master):
        self.master = master
        master.title("K Means Clustering")
        self.countries = None
        self.p = preprocessor()

        # start 1.1
        self.file_path = StringVar()
        self.label_file_browser = Label(master, text="File Path:")
        self.file_path_tb = Entry(master, textvariable=self.file_path, width=100)
        self.browse_button = Button(master, text="Browse", command=self.browse_files)

        self.label_file_browser.grid(row=0, column=0, sticky=W)
        self.file_path_tb.grid(row=0, column=1, sticky=W)
        self.browse_button.grid(row=0, column=2)

        # start 1.2
        self.cluster_num = 0
        self.runs_num = 0
        self.row_num = 150

        self.cluster_num_label = Label(master, text="Number of clusters k:")

        vcmd_cluster = master.register(self.validate_cluster)
        self.cluster_num_tb = Entry(master, validate="key", validatecommand=(vcmd_cluster, '%P'))

        self.cluster_num_label.grid(row=1, column=0, sticky=W)
        self.cluster_num_tb.grid(row=1, column=1, sticky=W)

        # start 1.3
        self.runs_num_label = Label(master, text="Number of runs:")

        vcmd_runs = master.register(self.validate_runs)
        self.runs_num_tb = Entry(master, validate="key", validatecommand=(vcmd_runs, '%P'))

        self.runs_num_label.grid(row=2, column=0, sticky=W)
        self.runs_num_tb.grid(row=2, column=1, sticky=W)

        # start 1.4
        self.process_button = Button(master, text="Pre-Process", command=self.pre_processing)
        self.process_button.grid(row=3, column=1, sticky=W)

        # start 1.5
        self.cluster_button = Button(master, text="Cluster", command=self.check_kmeans)
        self.cluster_button.grid(row=4, column=1, sticky=W)

    # open file browser menu
    def browse_files(self):
        file_name = filedialog.askopenfilename(initialdir="/",
                                               title="Select a file",
                                               filetypes=[("Excel files", "*.xlsx")])
        self.file_path.set(file_name)

    # verify cluster num is an integer > 0
    def validate_cluster(self, new_text):
        if not new_text:  # the field is being cleared
            self.cluster_num = 0
            return True

        try:
            self.cluster_num = int(new_text)
            if self.cluster_num < 1:
                error_msg("K clusters must be a positive integer")
                return False
            return True
        except ValueError:
            return False

    # verify runs num is an integer > 0
    def validate_runs(self, new_text):
        if not new_text:  # the field is being cleared
            self.runs_num = 0
            return True

        try:
            self.runs_num = int(new_text)
            if self.runs_num < 1:
                error_msg("Number of runs must be a positive integer")
                return False
            return True
        except ValueError:
            return False

    # verify input legality and call KMean
    def check_kmeans(self):
        if self.cluster_num < 1:
            error_msg("K clusters must be a positive integer")
            return False
        if self.runs_num < 1:
            error_msg("Number of runs must be a positive integer")
            return False
        if self.cluster_num > self.row_num:
            error_msg("Number of clusters must be a smaller than the number of rows")
            return False

        cluster = classify()
        error_msg(cluster.KMean(self.countries, self.cluster_num, self.runs_num))

        self.map_img = PhotoImage(file='countryMap.png')
        self.map_canvas = Canvas(self.master, width=self.map_img.width(), height=self.map_img.height())
        self.map_canvas.grid(row=5, column=0)
        self.map_canvas.create_image(0, 0, anchor=NW, image=self.map_img)

        self.scatter_img = PhotoImage(file='scatterGraph.png')
        self.scatter_canvas = Canvas(self.master, width=self.scatter_img.width(), height=self.scatter_img.height())
        self.scatter_canvas.grid(row=5, column=1)
        self.scatter_canvas.create_image(0, 0, anchor=NW, image=self.scatter_img)

    # verify path file legality and call pre-processing
    def pre_processing(self):
        if len(self.file_path.get()) > 0:
            _, self.countries, err_msg = self.p.preprocess(self.file_path.get())
            error_msg(err_msg)

            if self.countries is None:
                return False

            self.row_num = len(self.countries)

            return True
        else:
            error_msg("No file path provided")
            return False


window = Tk()
window.geometry("1280x720")
my_gui = Gui(window)
window.mainloop()
