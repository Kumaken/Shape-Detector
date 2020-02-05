from tkinter import *
from tkinter.filedialog import askopenfilename
from tkinter import messagebox
from PIL import ImageTk, Image
import testie
from image_process_contour import processImage

WIDTH = 1100
HEIGHT = 700
LIGHT_GREY = '#EDEBED'

fileImg = ""

root = Tk()
root.title('Shape Detector')
root.geometry(str(WIDTH)+'x'+str(HEIGHT))

top = Frame(root, height=400, bg=LIGHT_GREY)
bottom = Frame(root, height=300, bg=LIGHT_GREY)
src = Canvas(top, width=440)
dest = Frame(top, width=440)
options = Frame(top, width=220)
buttons = Frame(options, height=220, bg=LIGHT_GREY)
tree = Frame(options, height=180)
result = Frame(bottom)
fact = Frame(bottom)
rule = Frame(bottom)

def openImg():
    global fileImg
    fileImg = askopenfilename(title='Source Image', filetypes=[('Image files', '*.jpg')])
    try:
        img = ImageTk.PhotoImage(file=fileImg)
        display = Label(src, image=img)
        display.image = img
        display.pack(fill='both', expand=True)
    except (Exception, AttributeError):
        pass

def openEditor():
    global fileName
    try:
        fileName = askopenfilename(title='Rule Files', filetypes=[('CLIPS files', '*.clp')])
        window = Tk()
        window.title('Rule Editor')
        editor = Frame(window)
        editor.pack(fill=X)
        Button(window, text='Save', font=('Arial', 16, 'bold'), width=8, pady=4, command=lambda:[save, window.destroy()]).pack(side='bottom')
        content = Text(editor)
        scroll = Scrollbar(editor)
        scroll.config(command=content.yview)
        content.config(yscrollcommand=scroll.set)
        scroll.pack(side='right', fill=Y)
        content.pack(side='left', expand=True, fill='both')
        editor.content = content
        editor.pack(expand=True)
        text = open(fileName, 'r').read()
        content.delete('1.0', END)
        content.insert('1.0', text)
        content.mark_set(INSERT, '1.0')
        content.config(font=('Monaco', 12))
        content.focus()
    except FileNotFoundError:
        pass

def save(content, fileName):
    alltext = content.get('1.0', END+'-1c')
    open(fileName, 'w').write(alltext)
    messagebox.showinfo('Success', 'Rule successfully saved')

def openRules():
    window = Tk()
    window.title('Rules')
    editor = Frame(window)
    editor.pack(fill=X)
    content = Text(editor)
    scroll = Scrollbar(editor)
    scroll.config(command=content.yview)
    content.config(yscrollcommand=scroll.set)
    scroll.pack(side='right', fill=Y)
    content.pack(side='left', expand=True, fill='both')
    editor.pack(expand=True)
    text = open(fileName, 'r').read()
    content.insert('1.0', text)
    content.delete('0.1',END)
    content.insert(END, text)

def openFacts():
    window = Tk()
    window.title('Facts')
    editor = Frame(window)
    editor.pack(fill=X)
    content = Text(editor)
    scroll = Scrollbar(editor)
    scroll.config(command=content.yview)
    content.config(yscrollcommand=scroll.set)
    scroll.pack(side='right', fill=Y)
    content.pack(side='left', expand=True, fill='both')
    editor.pack(expand=True)
    text = '(shape (name acute-triangle) (edge-count 3) (angle-trait acute) (length-trait none))\n`\
        `(shape (name obtuse-triangle) (edge-count 3) (angle-trait obtuse) (length-trait none))\n`\
        `(shape (name right-triangle) (edge-count 3) (angle-trait perpendicular) (length-trait none))\n`\
        `(shape (name isosceles-right-triangle) (edge-count 3) (angle-trait perpendicular) (length-trait isosceles))\n`\
        `(shape (name isosceles-obtuse-triangle) (edge-count 3) (angle-trait obtuse) (length-trait isosceles))\n`\
        `(shape (name isosceles-acute-triangle) (edge-count 3) (angle-trait acute) (length-trait isosceles))\n\n`\
        `(shape (name equilateral-triangle) (edge-count 3) (angle-trait none) (length-trait equilateral))\n`\
        `(shape (name equilateral-triangle) (edge-count 3) (angle-trait acute) (length-trait equilateral))\n\n`\
        `(shape (name square) (edge-count 4) (angle-trait none) (length-trait equilateral))\n`\
        `(shape (name kite) (edge-count 4) (angle-trait none) (length-trait kite))\n`\
        `(shape (name rectangle) (edge-count 4) (angle-trait none) (length-trait none))\n\n`\
        `(shape (name regular-trapezium) (edge-count 4) (angle-trait trapezium) (length-trait none))\n`\
        `(shape (name isosceles-trapezium) (edge-count 4) (angle-trait trapezium) (length-trait isosceles))\n`\
        `(shape (name lefthand-trapezium) (edge-count 4) (angle-trait trapezium) (length-trait lefthand))\n`\
        `(shape (name righthand-trapezium) (edge-count 4) (angle-trait trapezium) (length-trait righthand))\n\n`\
        `(shape (name regular-pentagon) (edge-count 5) (angle-trait none) (length-trait none))\n`\
        `(shape (name equilateral-pentagon) (edge-count 5) (angle-trait none) (length-trait equilateral))\n\n`\
        `(shape (name regular-hexagon) (edge-count 6) (angle-trait none) (length-trait none))\n`\
        `(shape (name equilateral-hexagon) (edge-count 6) (angle-trait none) (length-trait equilateral))'
    content.insert('1.0', text)
    content.delete('0.1',END)
    content.insert(END, text)

def renderResults():
    length_slope_tuple = processImage(fileImg)
    testie.runKBS(length_slope_tuple)

    # process output
    rm, af, fr = [], [], []

    f = open("outputfile.txt", "r")
    for i in f:
        part = i.split(':')
        try:
            if "R_M_" in part[0]:
                rm.append(part[1])
            elif "A_F_" in part[0]:
                af.append(part[1])
            elif "F_R_" in part[0]:
                fr.append(part[1])
        except:
            print("Error")

    labelRes = Label(result, text="\n".join(fr)).place(x=result.winfo_width()/2, y=0)
    labelFact = Label(fact, text="\n".join(af)).place(x=fact.winfo_width()/2, y=0)
    labelRules = Label(rule, text="\n".join(rm)).place(x=rule.winfo_width()/2, y=0)

def initLayout():
    labelSI = Label(root, text='Source Image', bg=LIGHT_GREY).place(x=180, y=0)
    labelDI = Label(root, text='Destination Image', bg=LIGHT_GREY).place(x=618, y=0)
    labelTree = Label(root, text='What shape do you want?', bg=LIGHT_GREY).place(x=920, y=216)
    labelDR = Label(root, text='Detection Result', bg=LIGHT_GREY).place(x=136, y=420)
    labelMF = Label(root, text='Matched Facts', bg=LIGHT_GREY).place(x=510, y=420)
    labelHT = Label(root, text='Hit Rules', bg=LIGHT_GREY).place(x=890, y=420)

    labelImg = Label(src, text='Please choose an image', font=('Arial', 24, 'bold')).place(x=78, y=150)
    labelClickImg = Label(src, text='Choose \u2192 Open Image button', font=('Arial', 14)).place(x=120, y=180)
    labelShape = Label(dest, text='Please choose a shape', font=('Arial', 24, 'bold')).place(x=88, y=150)
    labelShape = Label(dest, text='Double-click shape tree item', font=('Arial', 14)).place(x=136, y=180)

    btnImg = Button(buttons, text='Open Image', width=200, pady=3, command=openImg)
    btnEdit = Button(buttons, text='Open Rule Editor', width=200, pady=3, command=openEditor)
    btnRule = Button(buttons, text='Show Rules', width=200, pady=3, command=openRules)
    btnFact = Button(buttons, text='Show Facts', width=200, pady=3, command=openFacts)
    btnRun = Button(buttons, text='Run', width=200, pady=3, command=renderResults)

    v = IntVar()

    choices = [
        ("Triangle"),
        ("Quadrilateral"),
        ("Pentagon"),
        ("Hexagon")]

    for val, choice in enumerate(choices):
        Radiobutton(tree,
                    text=choice,
                    indicatoron = 0,
                    width = 20,
                    padx = 20,
                    pady = 4,
                    variable=v,
                    command=v.get(),
                    value=val).pack(anchor=W)

    top.pack(expand=True, fill='both', pady=15)
    bottom.pack(expand=True, fill='both', pady=5)

    for cell in [src, dest, options, result, fact, rule]:
        cell.pack(expand=True, fill='both', side='left', padx=6, pady=10)

    buttons.pack(expand=True, fill='both', side='top')
    tree.pack(expand=True, fill='both', side='top', padx=6)

    for frame in [top, bottom, src, dest, options, tree, result, fact, rule, buttons]:
        frame.pack_propagate(0)

    for btn in [btnImg, btnEdit, btnRule, btnFact, btnRun]:
        btn.pack(pady=6)

root.configure(background=LIGHT_GREY)
initLayout()
root.mainloop()