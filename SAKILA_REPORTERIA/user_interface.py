import tkinter as tk
from tkinter import filedialog, messagebox, ttk
import pandas as pd
from file_operation import File_Operation
from database_operation import Database_Operation
from procesos import Procesos

class User_Interface:
    def __init__(self):
        self.files = File_Operation()
        self.data = Database_Operation()

        # Ventana principal
        self.ventana = tk.Tk()
        screen_width = self.ventana.winfo_screenwidth()
        screen_height = self.ventana.winfo_screenheight()
        self.ventana.title("Panel de Reportes")
        self.ventana.geometry(f"{screen_width}x{screen_height}")

        self.seccion_etl()
        self.seccion_dwh()
        self.seccion_csv()

        self.ventana.mainloop()

    def seccion_csv(self):
        frame_csv = tk.LabelFrame(self.ventana, text="📁 ARCHIVOS", padx=10, pady=10)
        frame_csv.pack(fill="both", expand=True, padx=10, pady=5)

        frame_scroll = tk.Frame(frame_csv)
        frame_scroll.pack(fill="x")

        canvas = tk.Canvas(frame_scroll, height=50)
        canvas.pack(side="left", fill="x", expand=True)

        scrollbar_x = tk.Scrollbar(frame_scroll, orient="horizontal", command=canvas.xview)
        scrollbar_x.pack(side="bottom", fill="x")

        canvas.configure(xscrollcommand=scrollbar_x.set)

        frame_botones = tk.Frame(canvas)
        canvas.create_window((0, 0), window=frame_botones, anchor="nw")

        for reporte in self.files.obtener_archivos():
            btn_tabla = tk.Button(frame_botones, text=(reporte.replace('_',' ').upper()).replace('.CSV',''), command=lambda r=reporte: self.accion_archivo(r))
            btn_tabla.pack(side="left", padx=5)
        
        frame_botones.bind("<Configure>", lambda e: self.actualizar_scroll(canvas))

        # Tabla para mostrar archivos CSV
        self.tree_csv = ttk.Treeview(frame_csv)
        self.tree_csv.pack(fill="both", expand=True, pady=10)

    def seccion_dwh(self):
        frame_tabla = tk.LabelFrame(self.ventana, text="🧮 REPORTES DWH", padx=10, pady=10)
        frame_tabla.pack(fill="both", expand=True, padx=10, pady=5)

        frame_scroll = tk.Frame(frame_tabla)
        frame_scroll.pack(fill="x")

        canvas = tk.Canvas(frame_scroll, height=50)
        canvas.pack(side="left", fill="x", expand=True)

        scrollbar_x = tk.Scrollbar(frame_scroll, orient="horizontal", command=canvas.xview)
        scrollbar_x.pack(side="bottom", fill="x")

        canvas.configure(xscrollcommand=scrollbar_x.set)

        frame_botones = tk.Frame(canvas)
        canvas.create_window((0, 0), window=frame_botones, anchor="nw")

        for key, reporte in self.data.ver_reportes():
            btn_tabla = tk.Button(frame_botones, text=reporte.replace('_',' ').upper(), command=lambda r=reporte: self.accion_reporte(r))
            btn_tabla.pack(side="left", padx=5)

        frame_botones.bind("<Configure>", lambda e: self.actualizar_scroll(canvas))

        # Tabla para mostrar reportes DWH
        self.tree_dwh = ttk.Treeview(frame_tabla)
        self.tree_dwh.pack(fill="both", expand=True, pady=10)

    def seccion_etl(self):
        frame_script = tk.LabelFrame(self.ventana, text="🚀 EJECUCIONES", padx=10, pady=10)
        frame_script.pack(fill="both", expand=True, padx=10, pady=5)

        btn_script = tk.Button(frame_script, text="ETL", command=self.ejecutar_etl)
        btn_script.pack()

    def actualizar_scroll(self, canvas):
        canvas.configure(scrollregion=canvas.bbox("all"))

    def cargar_csv(self):
        archivo = filedialog.askopenfilename(filetypes=[("Archivos CSV", "*.csv")])
        if archivo:
            try:
                df = pd.read_csv(archivo)
                self.mostrar_datos_en_tabla(df, self.tree_csv)
            except Exception as e:
                messagebox.showerror("Error", f"No se pudo leer el archivo:\n{e}")

    def accion_archivo(self, nombre):
        try:
            df = self.files.abrir_archivo(nombre)
            self.mostrar_datos_en_tabla(df, self.tree_csv)
        except Exception as e:
            messagebox.showerror("Error", f"No se pudo cargar el archivo:\n{e}")

    def accion_reporte(self, nombre):
        try:
            df = self.data.obtener_reporte_sakila_dwh(nombre)
            self.mostrar_datos_en_tabla(df, self.tree_dwh)
        except Exception as e:
            messagebox.showerror("Error", f"No se pudo cargar el reporte:\n{e}")

    def mostrar_datos_en_tabla(self, df, tree):
        tree.delete(*tree.get_children())
        tree["columns"] = list(df.columns)
        tree["show"] = "headings"

        for col in df.columns:
            tree.heading(col, text=col)
            tree.column(col, anchor="center")

        for _, row in df.iterrows():
            tree.insert("", "end", values=list(row))

    def ejecutar_etl(self):
        try:
            proceso = Procesos()
            if proceso.ejecutar_etl():
                messagebox.showinfo("Éxito", "Programa ejecutado correctamente.")
            else:
                messagebox.showerror("Error", "El proceso ETL no se completó correctamente.")
        except Exception as e:
            messagebox.showerror("Error", f"Fallo al ejecutar ETL:\n{e}")

# Para ejecutar la interfaz:
if __name__ == "__main__":
    User_Interface()
