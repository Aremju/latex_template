#!/bin/bash

# Name der Hauptdatei ohne Endung
MAIN_FILE="main"

# Ordner für die generierten Dateien
OUTPUT_FOLDER="out"

# Name der finalen PDF
FINAL_PDF_NAME="bachelorarbeit_julius_emil_arendt.pdf"

# Definierte Muster für generierte Dateien
generated_files_patterns=(
    "*.aux" "*.bbl" "*.blg" "*.log" "*.out" "*.toc" "*.lof" "*.lot"
    "*.fdb_latexmk" "*.fls" "*.synctex.gz" "*.glg" "*.glo" "*.gls" "*.ist"
    "*.glsdefs"
)

# Alte Dateien entfernen
echo "Bereinige vorherige generierte Dateien..."
for pattern in "${generated_files_patterns[@]}"; do
    find . -type f -name "$pattern" -exec rm -f {} + 2>/dev/null
done

echo "Bereinigung abgeschlossen. Starte Build-Prozess..."

# LaTeX-Dokument kompilieren
pdflatex $MAIN_FILE.tex
bibtex $MAIN_FILE.aux
makeglossaries $MAIN_FILE
pdflatex $MAIN_FILE.tex
pdflatex $MAIN_FILE.tex

# Ausgabeordner erstellen
mkdir -p $OUTPUT_FOLDER

# Generierte Dateien in den Ausgabeordner verschieben
echo "Verschiebe generierte Dateien in '$OUTPUT_FOLDER'..."
find . -type f \( \
    -name "*.aux" -o \
    -name "*.glsdefs" -o \
    -name "*.ist" -o \
    -name "*.bbl" -o \
    -name "*.blg" -o \
    -name "*.log" -o \
    -name "*.out" -o \
    -name "*.toc" -o \
    -name "*.lof" -o \
    -name "*.lot" -o \
    -name "*.fdb_latexmk" -o \
    -name "*.fls" -o \
    -name "*.synctex.gz" -o \
    -name "*.glg" -o \
    -name "*.glo" -o \
    -name "*.gls" \) -exec mv -t $OUTPUT_FOLDER {} + 2>/dev/null

# PDF umbenennen
if [ -f "$MAIN_FILE.pdf" ]; then
    mv -f "$MAIN_FILE.pdf" "$FINAL_PDF_NAME"
    echo "PDF wurde in '$FINAL_PDF_NAME' umbenannt."
else
    echo "Fehler: PDF-Datei '$MAIN_FILE.pdf' nicht gefunden!"
fi

echo "Build abgeschlossen. Alle Dateien sind in '$OUTPUT_FOLDER'. Generierte PDF: $FINAL_PDF_NAME"
