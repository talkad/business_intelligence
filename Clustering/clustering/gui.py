from tkinter import *
from tkinter import filedialog
from tkinter import Tk, Label, Button, Entry, IntVar, END, W, E
import tkinter.messagebox
from preprocessor import preprocessor


def cluster_error_msg():
    tkinter.messagebox.showinfo("K Means Clustering", "K clusters must be a positive integer")


def runs_error_msg():
    tkinter.messagebox.showinfo("K Means Clustering", "Number of runs must be a positive integer")


def file_error_msg():
    tkinter.messagebox.showinfo("K Means Clustering", "No file path provided")


class Gui:

    def __init__(self, master):
        self.master = master
        master.title("K Means Clustering")

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

        self.cluster_num_label = Label(master, text="Number of clusters k:")

        vcmd_cluster = master.register(self.validate_cluster)  # we have to wrap the command
        self.cluster_num_tb = Entry(master, validate="key", validatecommand=(vcmd_cluster, '%P'))

        self.cluster_num_label.grid(row=1, column=0, sticky=W)
        self.cluster_num_tb.grid(row=1, column=1, sticky=W)

        # start 1.3
        self.runs_num_label = Label(master, text="Number of runs:")

        vcmd_runs = master.register(self.validate_runs)  # we have to wrap the command
        self.runs_num_tb = Entry(master, validate="key", validatecommand=(vcmd_runs, '%P'))

        self.runs_num_label.grid(row=2, column=0, sticky=W)
        self.runs_num_tb.grid(row=2, column=1, sticky=W)

        # start 1.4
        self.process_button = Button(master, text="Pre-Process", command=self.pre_processing)  # todo add function
        self.process_button.grid(row=3, column=1, sticky=W)

        # start 1.5
        self.cluster_button = Button(master, text="Cluster", command=self.check_kmeans)
        self.cluster_button.grid(row=4, column=1, sticky=W)

        # self.cluster_canvas = Canvas(master, width=300, height=300) # todo this is template for showing pic
        # self.cluster_canvas.grid(row=5, column=0)
        # self.img = PhotoImage(file='apple.png')
        # self.cluster_canvas.create_image(0, 0, anchor=NW, image=self.img)

    def browse_files(self):
        file_name = filedialog.askopenfilename(initialdir="/",
                                               title="Select a file",
                                               filetypes=[("Excel files", "*.xlsx")])
        self.file_path.set(file_name)
        # Change label contents
        # label_file_explorer.configure(text="File Opened: " + filename)

    def validate_cluster(self, new_text):
        if not new_text:  # the field is being cleared
            self.cluster_num = 0
            return True

        try:
            self.cluster_num = int(new_text)
            if self.cluster_num < 1:
                cluster_error_msg()
                return False
            return True
        except ValueError:
            return False

    def validate_runs(self, new_text):
        if not new_text:  # the field is being cleared
            self.runs_num = 0
            return True

        try:
            self.runs_num = int(new_text)
            if self.runs_num < 1:
                runs_error_msg()
                return False
            return True
        except ValueError:
            return False

    def check_kmeans(self):
        if self.cluster_num < 1:
            cluster_error_msg()
            return False
        if self.runs_num < 1:
            runs_error_msg()
            return False
        return 0  # todo kmeans()

    def pre_processing(self):
        if len(self.file_path.get()) > 0:
            preprocessor.load_data(self.p, self.file_path.get())  # todo check i actually need the get
            # and ask tal what to do with it
            return True
        else:
            file_error_msg()
            return False


window = Tk()
window.geometry("1000x500")
my_gui = Gui(window)
window.mainloop()
