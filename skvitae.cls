%%% A class to produce a nice-looking Curriculum Vitae.
%%% Simon Sigurdhsson <sigurdhsson@gmail.com>
%%% Forked from http://github.com/kjhealy/kjh-vita
%%% Kieran Healy <kjhealy@gmail.com>
\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{skvitae}[2013/01/06 v1.0 skvitae curriculum vitae class]
\RequirePackage{xstring,xparse}

%\RequirePackage{kvoptions}
%\SetupKeyvalOptions{family=skrapport,prefix=skrapport@}

\RequirePackage{ifxetex,ifluatex}
\ifxetex\else\ifluatex\else
\ClassError{skvitae}{Requires XeTeX or luaTeX!}
{Please run using the `xelatex' or `lualatex' commands.}
\fi\fi

\LoadClass[11pt]{article}

\DeclareDocumentCommand\author{m}{\gdef\@author{#1}}
\DeclareDocumentCommand\affiliation{m}{\gdef\@affiliation{#1}}
\DeclareDocumentCommand\street{m}{\gdef\@street{#1}}
\DeclareDocumentCommand\city{m}{\gdef\@city{#1}}
\DeclareDocumentCommand\email{m}{\gdef\@email{#1}}
\DeclareDocumentCommand\web{m}{\gdef\@web{#1}}
\DeclareDocumentCommand\phone{m}{\gdef\@phone{#1}}
\DeclareDocumentCommand\mobile{m}{\gdef\@mobile{#1}}
\DeclareDocumentCommand\keywords{m}{\gdef\@keywords{#1}}

\IfFileExists{vc.tex}{
  \input{vc}
}{
  \def\VCRevision{}
  \def\VCModifiedText{}
  \def\VCDateISO{}
}

\RequirePackage{url,fancyhdr}
\RequirePackage{fontspec,xunicode}
\RequirePackage[usenames,dvipsnames]{xcolor}

\AtBeginDocument{\RequirePackage[xetex, 
    colorlinks=true,
    urlcolor=BlueViolet,
    plainpages=false,
    pdfpagelabels,
    bookmarksnumbered,
    pdftitle={Curriculim Vitae},
    pagebackref,
    pdfauthor={\@author},
    pdfkeywords={\@keywords}
]{hyperref}}

\setromanfont[Mapping=tex-text,Numbers={OldStyle},Ligatures={Common}]{Minion Pro} 
\setsansfont[Mapping=tex-text,Colour=AA0000]{Myriad Pro}
\setmonofont[Mapping=tex-text,Scale=0.9]{Monaco} 

\DeclareDocumentCommand\section{som}{
  \bigskip\par
  \marginpar{
    \textbf{
      \textsf{
        \footnotesize\vspace{-1em}
        \flushright\MakeLowercase{#3}
      }
    }
  }
}
\DeclareDocumentCommand\subsection{som}{
  \noindent\emph{#3}\smallskip
}
\DeclareDocumentCommand\amper{}{
  {\fontspec[Scale=.95,Colour=AA0000]{Minion Pro Medium}\selectfont\&\,}
}
\RenewDocumentCommand\labelitemi{}{~} 
\RenewDocumentCommand\labelitemii{}{~} 

\DeclareDocumentCommand\ind{}{
  \par\hangindent=1 true cm\hangafter=1 \noindent
}

\pagestyle{fancy}
\renewcommand{\headrulewidth}{0pt}
\fancyhead{}
\fancyfoot{}
\rhead{{\scriptsize\thepage}}
\rfoot{\textcolor{Gray}{\scriptsize\texttt{\VCRevision}\ on \VCDateISO\\\VCModifiedText}} 

\DeclareDocumentCommand\marvosymbol{m}{{\fontfamily{mvs}\fontencoding{U}\fontseries{m}\fontshape{n}\selectfont\char#1}}

\DeclareDocumentCommand\maketitle{}{
  \hfill
  \begin{minipage}[t]{2.95in}
    \begingroup\flushright\footnotesize
    \@ifundefined{\@affiliation}{\@author}{\@affiliation} \\
    \@street \\
    \@city \\
    \endgroup
  \end{minipage}
  \begin{minipage}[t]{1.7in}
    \begingroup\flushright\footnotesize
    \marvosymbol{84}\ \@phone \\
    \marvosymbol{72}\ \@mobile \\
    \hfill\hbox{\scriptsize\texttt{\href{mailto:\@email}{\@email}}}
    \mbox{}\\
    \endgroup
  \end{minipage}
  \par\medskip\par
  \noindent{\Large{\textsc{\expandafter\MakeLowercase{\@author}}}}
  \reversemarginpar
  \par\vspace{-\bigskipamount}\medskip
}