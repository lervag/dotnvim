local snippets = {
  {
    prefix = "nom",
    desc = "\\nomenclature",
    body = [[\nomenclature[${1:A}]{${2:short}}{${3:long}}${0}]],
  },
  {
    prefix = "qty",
    desc = "\\qty{}{}",
    body = [[\qty{${1:number}}{${2:unit}}${0}]],
  },
  {
    prefix = "SI",
    desc = "\\qty{}{}",
    body = [[\qty{${1:number}}{${2:unit}}${0}]],
  },
  {
    prefix = "sec",
    desc = "\\section{}",
    body = [[\section{${1:title}}${0}]],
  },
  {
    prefix = "sub",
    desc = "\\subsection{}",
    body = [[\subsection{${1:title}}${0}]],
  },
  {
    prefix = "subsub",
    desc = "\\subsubsection{}",
    body = [[\subsubsection{${1:title}}${0}]],
  },
  {
    prefix = "env",
    desc = "Environment",
    body = {
      "\\begin{$1}",
      "  $0",
      "\\end{$1}",
    },
  },
  {
    prefix = "equation",
    desc = "Environment: equation",
    body = {
      "\\begin{equation}",
      "  $0",
      "\\end{equation}",
    },
  },
  {
    prefix = "align",
    desc = "Environment: align",
    body = {
      "\\begin{align}",
      "  $0",
      "\\end{align}",
    },
  },
  {
    prefix = "itemize",
    desc = "Environment: itemize",
    body = {
      "\\begin{itemize}",
      "  $0",
      "\\end{itemize}",
    },
  },
  {
    prefix = "enumerate",
    desc = "Environment: enumerate",
    body = {
      "\\begin{enumerate}",
      "  $0",
      "\\end{enumerate}",
    },
  },
  {
    prefix = "description",
    desc = "Environment: description",
    body = {
      "\\begin{description}",
      "  $0",
      "\\end{description}",
    },
  },
  {
    prefix = "table",
    desc = "Environment: table",
    body = {
      "\\begin{table}",
      "  \\centering",
      "  \\caption{$1}",
      "  \\label{tab:$2}",
      "  \\begin{tabular}{$3}",
      "    \\toprule",
      "    $4",
      "    \\midrule",
      "    $0",
      "    \\bottomrule",
      "  \\end{tabular}",
      "\\end{table}",
    },
  },
  {
    prefix = "figure",
    desc = "Environment: figure",
    body = {
      "\\begin{figure}",
      "  \\centering",
      "  \\includegraphics{$1}",
      "  \\caption{$3}",
      "  \\label{fig:$2}",
      "\\end{figure}",
    },
  },
  {
    prefix = "tikzpicture",
    desc = "Environment: figure tikzpicture",
    body = {
      "\\begin{figure}",
      "  \\centering",
      "  \\begin{tikzpicture}",
      "    $0",
      "  \\end{tikzpicture}",
      "  \\caption{$2}",
      "  \\label{fig:$1}",
      "\\end{figure}",
    },
  },
  {
    prefix = "pgfplot",
    desc = "Environment: figure pgfplot",
    body = {
      "\\begin{figure}",
      "  \\centering",
      "  \\begin{tikzpicture}",
      "    \\begin{axis}",
      "      \\addplot[color=red, mark=x] ${0}",
      "    \\end{axis}",
      "  \\end{tikzpicture}",
      "  \\caption{$2}",
      "  \\label{fig:$1}",
      "\\end{figure}",
    },
  },
  {
    prefix = "frame",
    desc = "Environment: frame",
    body = {
      "\\begin{frame}{${1:Title}}",
      "  $0",
      "\\end{frame}",
    },
  },
  {
    prefix = "template-minimal",
    desc = "Template: Minimal",
    body = [[
\documentclass{minimal}
\begin{document}

Hello World!${0}

\end{document}
]],
  },
  {
    prefix = "template-article",
    desc = "Template: Article",
    body = [[
\documentclass{article}
\usepackage[utf8]{inputenc}
\usepackage{graphicx}
${1}

\begin{document}

${0}

\end{document}
]],
  },
  {
    prefix = "template-tikz",
    desc = "Template: Standalone TikZ figure",
    body = [[
\documentclass{standalone}
\usepackage{tikz}
\usetikzlibrary{arrows}
\usetikzlibrary{positioning}
\usetikzlibrary{calc}
\begin{document}

\begin{tikzpicture}
	[
		thick
	]
	${0}
\end{tikzpicture}

\end{document}
]],
  },
  {
    prefix = "template-pdfinclude",
    desc = "Template: Include PDF",
    body = [[
\documentclass[a4]{article}
\usepackage{pdfpages}
\usepackage{tikz}
\pagestyle{empty}
\begin{document}

\includepdf[
	fitpaper,
	pages={1},
	pagecommand={
		\tikz[overlay, remember picture] {...}
	}
]{$0}

\end{document}
]],
  },
}

return snippets
