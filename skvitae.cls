%%% A class to produce a nice-looking Curriculum Vitae.
%%% Simon Sigurdhsson <sigurdhsson@gmail.com>
%%% Forked from http://github.com/kjhealy/kjh-vita
%%% Kieran Healy <kjhealy@gmail.com>
\RequirePackage{expl3,xstring,xparse}
\ProvidesExplClass{skvitae}{2014/10/20}{2.0}
  {skvitae curriculum vitae class}
\LoadClass[12pt]{article}
\RequirePackage{l3regex}

% Error messages
\msg_new:nnnn{skvitae}{missing-contact-info}{Contact~info~field~`#1'~is~missing!}
  {Please~provide~the~appropriate~value~using~`\token_to_str:N\SetupContactInfo'.}
\msg_new:nnnn{skvitae}{requires-xeluatex}{This~class~requires~XeTeX~or~luaTeX!}
  {Please~compile~using~the~`xelatex`~or~`lualatex`~engine(s).}
\msg_new:nnnn{skvitae}{incorrect-usage}{Incorrect~use~of~`\token_to_str:N#1':~#2!}
    {I~will~try~to~recover~from~this~by~#3.}

% Check for XeTeX/LuaTeX
\bool_if:nF{\xetex_if_engine_p: || \luatex_if_engine_p:}{
  \msg_error:nn{skvitae}{requires-xeluatex}
}

% Contact info setup macro
\keys_define:nn{skvitae / local}{
  name    .tl_gset:N = \g__skvitae_name_tl,
  title   .tl_gset:N = \g__skvitae_title_tl,
  company .tl_gset:N = \g__skvitae_company_tl,
  street  .tl_gset:N = \g__skvitae_street_tl,
  zip     .tl_gset:N = \g__skvitae_zip_tl,
  city    .tl_gset:N = \g__skvitae_city_tl,
  country .tl_gset:N = \g__skvitae_country_tl,
  email   .tl_gset:N = \g__skvitae_email_tl,
  web     .tl_gset:N = \g__skvitae_web_tl,
  phone   .tl_gset:N = \g__skvitae_phone_tl,
  mobile  .tl_gset:N = \g__skvitae_mobile_tl,
  github  .tl_gset:N = \g__skvitae_github_tl,
}
\DeclareDocumentCommand\SetupContactInfo{+m}{
  \keys_set:nn{skvitae / local}{#1}
  \clist_map_function:nN
    {name,title,company,street,zip,city}
    \__skvitae_check_required_field:n
  \__skvitae_regex_global_replace_once:nnN{([[:digit:]]{2})([[:digit:]]{3})\Z}
    {\1\c{,}\2}\g__skvitae_zip_tl
  \__skvitae_regex_global_replace_once:nnN{(\+[[:digit:]]{2})(7?[[:digit:]]{2})}
    {\1\c{,}\2--}\g__skvitae_mobile_tl
  \__skvitae_regex_global_replace_once:nnN{\A(07?[[:digit:]]{2})}
    {\1--}\g__skvitae_mobile_tl
  \__skvitae_regex_global_replace_once:nnN{([[:digit:]]{2})([[:digit:]]{2})([[:digit:]]{2})\Z}
    {\1\c{,}\2\c{,}\3}\g__skvitae_mobile_tl
  \__skvitae_regex_global_replace_once:nnN{(\+[[:digit:]]{2})(7?[[:digit:]]{2})}
    {\1\c{,}\2--}\g__skvitae_phone_tl
  \__skvitae_regex_global_replace_once:nnN{\A(07?[[:digit:]]{2})}
    {\1--}\g__skvitae_phone_tl
  \__skvitae_regex_global_replace_once:nnN{([[:digit:]]{2})([[:digit:]]{2})([[:digit:]]{2})\Z}
    {\1\c{,}\2\c{,}\3}\g__skvitae_phone_tl
}
\cs_new:Npn\__skvitae_check_required_field:n#1{
  \tl_if_empty:cT{g__skvitae_#1_tl}{
    \msg_error:nnn{skvitae}{missing-contact-info}{#1}
  }
}
\cs_new:Npn\__skvitae_phone_or_mobile:{
  \tl_if_empty:NTF\g__skvitae_phone_tl{
    \tl_if_empty:NTF\g__skvitae_mobile_tl{
      \msg_warning:nnnnn{skvitae}{incorrect-usage}{\__skvitae_phone_or_mobile:}
        {phone~and~mobile~both~missing}{returning~an~empty~string}
    }{
      \tl_use:N\g__skvitae_mobile_tl
    }
  }{
    \tl_use:N\g__skvitae_phone_tl
  }
}
\cs_new:Npn\__skvitae_regex_global_replace_once:nnN#1#2#3{
  \tl_set_eq:NN\l_tmpa_tl#3
  \regex_replace_once:nnN{#1}{#2}\l_tmpa_tl
  \tl_gset_eq:NN#3\l_tmpa_tl
}

\file_if_exist:nTF{vc.tex}{
  \file_input:n{vc.tex}
}{
  \def\VCRevision{}
  \def\VCModifiedText{}
  \def\VCDateISO{}
}

\RequirePackage[final]{microtype}
\RequirePackage{url,fancyhdr,marginnote}
\RequirePackage{fontspec,xunicode}
\RequirePackage[usenames,dvipsnames]{xcolor}

\AtBeginDocument{\RequirePackage[\xetex_if_engine:TF{xetex}{luatex},
    colorlinks=true,
    urlcolor=BlueViolet,
    plainpages=false,
    pdfpagelabels,
    bookmarksnumbered,
    pdftitle={Curriculim Vitae},
    pagebackref,
    pdfauthor={\tl_use:N\g__skvitae_name_tl},
    pdfkeywords={CV, Resume, \tl_use:N\g__skvitae_name_tl}
]{hyperref}}

\defaultfontfeatures{Numbers=OldStyle,Ligatures=Common,Kerning=Uppercase,Mapping=tex-text}
\setmainfont{Minion ~ Pro}
\setsansfont[Colour=AA0000]{Cronos ~ Pro}
\setmonofont[Scale=MatchLowercase]{Input ~ Sans}
\usepackage{fontawesome}

\DeclareDocumentCommand\section{som}{
  \bigskip\par
  \marginnote{
    \footnotesize
    \llap{
      \textbf{
        \textsf{
          \MakeLowercase{#3}
        }
      }
    }\mbox{}
  }
}
\DeclareDocumentCommand\subsection{som}{
  \par\noindent\emph{#3}\smallskip
}
\DeclareDocumentCommand\amper{}{
  {\fontspec[Scale=.95,Colour=AA0000]{Minion Pro Medium}\selectfont\&\,}
}
\DeclareDocumentCommand\ind{}{
  \par\hangindent=1 true cm\hangafter=1 \noindent
}
\DeclareDocumentCommand\SkvitaeItem{o}{
  \ind
  \IfNoValueF{#1}{#1.~}
}
\DeclareDocumentEnvironment{itemize}{}{
  \cs_set_eq:NN\item\SkvitaeItem
}{
  % empty
}

\pagestyle{fancy}
\renewcommand{\headrulewidth}{0pt}
\fancyhead{}
\fancyfoot{}
\rhead{{\scriptsize\thepage}}
\rfoot{\textcolor[gray]{0.85}{\scriptsize\texttt{\VCRevision}\ on \VCDateISO}}%\\\VCModifiedText}}

\DeclareDocumentCommand\maketitle{}{
  \hfill
  \begin{minipage}[t]{2.95in}
    \begingroup\flushright\footnotesize
    \tl_use:N\g__skvitae_name_tl \\
    \tl_use:N\g__skvitae_street_tl \\
    \tl_use:N\g__skvitae_zip_tl \  \tl_use:N\g__skvitae_city_tl \\
    %\tl_if_empty:NF\g__skvitae_country_tl{\tl_use:N\g__skvitae_country_tl \\}
    \endgroup
  \end{minipage}
  \begin{minipage}[t]{1.7in}
    \begingroup\flushright\footnotesize
    %\@ifundefined{\@phone}{\mbox{}}{\faicon{phone}\ \@phone} \\
    \scalebox{0.9}{\raisebox{-.125ex}{\faicon{github}}}%
      \hspace{.5em}\tl_use:N\g__skvitae_github_tl \\
    \scalebox{0.9}{\raisebox{-.25ex}{\faicon{phone}}}%
      \hspace{.5em}\tl_use:N\g__skvitae_mobile_tl \\
    \tl_if_empty:NF\g__skvitae_email_tl{
      \hfill\hbox{\scriptsize\texttt{\href{mailto:\tl_use:N\g__skvitae_email_tl}
                                          {\tl_use:N\g__skvitae_email_tl}}}
      \mbox{}\\
    }
    \endgroup
  \end{minipage}
  \par\medskip\par
  \noindent{\Large{\textsc{\expandafter\MakeLowercase{\tl_use:N\g__skvitae_name_tl}}}}
  \reversemarginpar
  \par\vspace{-\bigskipamount}\medskip
}
