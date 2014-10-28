%%% A class to produce a nice-looking Curriculum Vitae.
%%% Simon Sigurdhsson <sigurdhsson@gmail.com>
%%% Forked from http://github.com/kjhealy/kjh-vita
%%% Kieran Healy <kjhealy@gmail.com>
\RequirePackage{expl3,xstring,xparse}
\ProvidesExplClass{skvitae}{2014/10/20}{2.0}
  {skvitae curriculum vitae class}
\RequirePackage{l3regex,etoolbox}

% Now based on the KOMA-script article class
\LoadClass{scrartcl}
\KOMAoptions{
  parskip = never,
  headings = small,
  DIV = 11,
}

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
\keys_define:nn{skvitae / contact-info}{
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
  \keys_set:nn{skvitae / contact-info}{#1}
  \clist_map_function:nN
    {name,title,company,street,zip,city}
    \__skvitae_check_required_field:n
  \__skvitae_regex_global_replace_once:nnN{([[:digit:]]{3})([[:digit:]]{2})\Z}
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

% Contact info helper macros
\coffin_new:N\g__skvitae_tempa_coffin
\coffin_new:N\g__skvitae_tempb_coffin
\coffin_new:N\g__skvitae_tempc_coffin
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
\cs_new:Npn\__skvitae_linked_email:{
  \href{mailto:\tl_use:N\g__skvitae_email_tl}
       {\tl_use:N\g__skvitae_email_tl}
}
\cs_new:Npn\__skvitae_linked_web:{
  \href{\tl_use:N\g__skvitae_web_tl}
       {\tl_use:N\g__skvitae_web_tl}
}
\cs_new:Npn\__skvitae_regex_global_replace_once:nnN#1#2#3{
  \tl_set_eq:NN\l_tmpa_tl#3
  \regex_replace_once:nnN{#1}{#2}\l_tmpa_tl
  \tl_gset_eq:NN#3\l_tmpa_tl
}
\cs_new:Npn\__skvitae_format_date_range_to_coffin_with_style:NNNn#1#2#3#4{
  \int_compare:nNnT {#1} > {\c_zero} {
    \hcoffin_set:Nn \l_tmpa_coffin {#4 \int_use:N#1}
    \int_compare:nNnT {#2} > {#1} {
      \hcoffin_set:Nn \l_tmpb_coffin {#4 --}
      \coffin_attach:NnnNnnnn \l_tmpa_coffin {H} {r} \l_tmpb_coffin {H} {l} {0pt} {0pt}
      \int_compare:nNnF {#2} = {\c_max_int} {
        \hcoffin_set:Nn \l_tmpb_coffin {#4 \int_use:N#2}
        \coffin_attach:NnnNnnnn \l_tmpa_coffin {b} {l} \l_tmpb_coffin {t} {l} {2ex} {-.5ex}
       }
    }
  }
  \vcoffin_set:Nnn #3 { \dim_eval:n{3\coffin_wd:N\l_tmpa_coffin} } { \strut }
  \int_compare:nTF {\c_max_int != #2 > #1} {
    \coffin_join:NnnNnnnn #3 {H} {l} \l_tmpa_coffin {H} {l} {0pt} {1ex}
  }{
    \coffin_join:NnnNnnnn #3 {H} {l} \l_tmpa_coffin {H} {l} {0pt} {0pt}
  }
}

% Single item macros
\AtEndPreamble{
  \tl_gset:Nn\g__skvitae_at_word_tl{at}
  \tl_gset:Nn\g__skvitae_in_word_tl{in}
  \tl_gset:Nn\g__skvitae_pdhthesis_word_tl{Ph.D. ~ thesis}
  \tl_gset:Nn\g__skvitae_mscthesis_word_tl{Master's ~ thesis}
  \tl_gset:Nn\g__skvitae_bscthesis_word_tl{Bachelor ~ thesis}
  \gappto\captionsswedish{
    \tl_gset:Nn\g__skvitae_at_word_tl{hos}
    \tl_gset:Nn\g__skvitae_in_word_tl{i}
    \tl_gset:Nn\g__skvitae_pdhthesis_word_tl{Doktorsavhandling}
    \tl_gset:Nn\g__skvitae_mscthesis_word_tl{Examensarbete}
    \tl_gset:Nn\g__skvitae_bscthesis_word_tl{Kandidatarbete}
  }
}
\cs_gset_eq:NN\Current\c_max_int
% Work items
\keys_define:nn{skvitae / work-item}{
  from      .int_set:N = \l__skvitae_witem_from_int,
  to        .int_set:N = \l__skvitae_witem_to_int,
  title     .tl_set:N  = \l__skvitae_witem_title_tl,
  org       .tl_set:N  = \l__skvitae_witem_org_tl,
  city      .tl_set:N  = \l__skvitae_witem_city_tl,
  glue-word .tl_set:N  = \l__skvitae_witem_glue_word_tl,
  glue-word .initial:n = {\tl_use:N\g__skvitae_at_word_tl},
}
\DeclareDocumentCommand\WorkItem{+m}{
  \keys_set:nn{skvitae / work-item}{#1}

  \__skvitae_format_date_range_to_coffin_with_style:NNNn
    \l__skvitae_witem_from_int \l__skvitae_witem_to_int
    \g__skvitae_tempc_coffin {\datefont\scshape\scriptsize}

  \skip_vertical:n{.5ex}
  {
    \coffin_typeset:Nnnnn \g__skvitae_tempc_coffin {H} {r} {0pt} {0pt}
    \tl_use:N\l__skvitae_witem_title_tl {}~
    \tl_use:N\l__skvitae_witem_glue_word_tl {}~
    \emph{\tl_use:N\l__skvitae_witem_org_tl} ,~
    \tl_use:N\l__skvitae_witem_city_tl .
  }
  \skip_vertical:n{.5ex}
}
% Education items
\keys_define:nn{skvitae / edu-item}{
  from      .int_set:N = \l__skvitae_eitem_from_int,
  to        .int_set:N = \l__skvitae_eitem_to_int,
  level      .tl_set:N = \l__skvitae_eitem_level_tl,
  field      .tl_set:N = \l__skvitae_eitem_field_tl,
  school     .tl_set:N = \l__skvitae_eitem_school_tl,
  extra   .clist_set:N = \l__skvitae_eitem_extra_clist,
}
\DeclareDocumentCommand\EduItem{+m}{
  \keys_set:nn{skvitae / edu-item}{#1}

  \__skvitae_format_date_range_to_coffin_with_style:NNNn
    \l__skvitae_eitem_from_int \l__skvitae_eitem_to_int
    \g__skvitae_tempc_coffin {\datefont\scshape\scriptsize}

  \skip_vertical:n{.5ex}
  {
    \coffin_typeset:Nnnnn \g__skvitae_tempc_coffin {H} {r} {0pt} {0pt}
    \tl_if_empty:NF\l__skvitae_eitem_field_tl{
      \tl_if_empty:NTF\l__skvitae_eitem_level_tl{
        \tl_use:N\l__skvitae_eitem_field_tl ,~
      }{
        \tl_use:N\l__skvitae_eitem_level_tl {}~
        ( \tl_use:N\l__skvitae_eitem_field_tl ) ,~
      }
    }
    \tl_use:N\l__skvitae_eitem_school_tl .

    \clist_map_inline:Nn\l__skvitae_eitem_extra_clist{
      \par {##1.}
    }
  }
  \skip_vertical:n{.5ex}
}
\keys_define:nn{skvitae / thesis}{
  title    .tl_set:N   = \l__skvitae_thesis_title_tl,
  language .tl_set:N   = \l__skvitae_thesis_language_tl,
  type     .choices:nn = {phd,msc,bsc}
                         {\tl_set_eq:Nc\l__skvitae_thesis_type_tl{g__skvitae_##1thesis_word_tl}},
}
\DeclareDocumentCommand\Thesis{+m}{
  \keys_set:nn{skvitae / thesis}{#1}

  \tl_use:N\l__skvitae_thesis_type_tl :~
  \foreignquote{\tl_use:N\l__skvitae_thesis_language_tl}
               {\tl_use:N\l__skvitae_thesis_title_tl}
}
% Other items
% ???

% Version control information
\file_if_exist:nTF{vc.tex}{
  \file_input:n{vc.tex}
}{
  \def\VCRevision{}
  \def\VCModified{}
  \def\VCDateISO{}
}

% Packages
\RequirePackage[final]{microtype}
\RequirePackage{url,fancyhdr,ragged2e}
\RequirePackage{fontspec,xunicode}
\RequirePackage{titlesec,fancyhdr}
\RequirePackage[usenames,dvipsnames]{xcolor}

% hyperref metadata
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

% Fonts
\defaultfontfeatures{Mapping=tex-text}
\setmainfont[
  Ligatures = Common, Numbers = OldStyle,
]{Adobe ~ Jenson ~ Pro}
\setsansfont{Cronos ~ Pro}
\setmonofont[Scale=MatchLowercase]{Input ~ Sans}
\newfontfamily\sectionfont{Adobe ~ Caslon ~ Pro}[
  Ligatures = Rare, Numbers = OldStyle,
]
\newfontfamily\subsectionfont{Adobe ~ Caslon ~ Pro}[
  Ligatures = Rare, Numbers = OldStyle,
]
\newfontfamily\datefont{Adobe ~ Jenson ~ Pro}[
  Ligatures = Common, Numbers = OldStyle,
]
\newfontfamily\contactfont{Adobe ~ Jenson ~ Pro}[
  Ligatures = Rare, Numbers = OldStyle,
]

% Restyling KOMA-script fonts and things
\setcounter{secnumdepth}{-2}
\setkomafont{section}{\sectionfont\mdseries\Large}
\setkomafont{subsection}{\subsectionfont\bfseries\small}
\titlespacing{\section}{0pt}{1.25em}{0.50em}
\titlespacing{\subsection}{0pt}{2ex}{2ex}

% Header and footer
\pagestyle{fancy}
\fancyhead{}
\fancyfoot[C]{\small\__skvitae_typeset_adress:}
\fancyfoot[R]{
  \textcolor[gray]{0.85}{
    \scriptsize \null \\
    \texttt{\VCRevision} ~ on ~ \VCDateISO
    \int_compare:nNnF {\VCModified} = {\c_zero}{
      \\ \color[HTML]{FF4136} with ~ local ~ modifications!
    }
  }
}
\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0pt}

% Name, address etc
\cs_new:Npn\__skvitae_typeset_adress:{
  \itshape
  \tl_use:N\g__skvitae_name_tl {}~ \(\cdot\) ~
  \tl_use:N\g__skvitae_street_tl {}~ \(\cdot\) ~
  \tl_use:N\g__skvitae_zip_tl {}~ \tl_use:N\g__skvitae_city_tl
  \tl_if_empty:NF\g__skvitae_country_tl{~ \(\cdot\) ~ \tl_use:N\g__skvitae_country_tl}
}
\cs_new:Npn\__skvitae_typeset_name_to_coffin:N#1{
  \hcoffin_set:Nn #1             {\contactfont \huge \tl_use:N\g__skvitae_name_tl}
  \hcoffin_set:Nn \l_tmpa_coffin {\contactfont \tl_use:N\g__skvitae_title_tl   \strut}
  \hcoffin_set:Nn \l_tmpb_coffin {\contactfont \tl_use:N\g__skvitae_company_tl \strut}
  \coffin_join:NnnNnnnn #1 {r} {H} \l_tmpa_coffin {r} {t} {0pt} {-1ex}
  \coffin_join:NnnNnnnn #1 {r} {B} \l_tmpb_coffin {r} {t} {0pt} {-1ex}
}
\cs_new:Npn\__skvitae_typeset_contact_info_to_coffin:N#1{
  \hcoffin_set:Nn #1             {\contactfont \__skvitae_phone_or_mobile:}
  \hcoffin_set:Nn \l_tmpa_coffin {\ttfamily {\small \__skvitae_linked_email:} \strut}
  \hcoffin_set:Nn \l_tmpb_coffin {\ttfamily {\small \__skvitae_linked_web:}   \strut}
  \coffin_join:NnnNnnnn #1 {l} {H} \l_tmpa_coffin {l} {t} {0pt} {-1ex}
  \coffin_join:NnnNnnnn #1 {l} {B} \l_tmpb_coffin {l} {t} {0pt} {-1ex}
}

\DeclareDocumentCommand\maketitle{}{
  \__skvitae_typeset_contact_info_to_coffin:N\g__skvitae_tempb_coffin
  \hcoffin_set:Nn \g__skvitae_tempa_coffin {
    \rule[.75ex] {.5pt} { \dim_eval:n{\coffin_ht:N\g__skvitae_tempb_coffin +
                                      \coffin_dp:N\g__skvitae_tempb_coffin + 1.5ex} }
  }
  \coffin_attach:NnnNnnnn \g__skvitae_tempb_coffin {vc} {l}
                        \g__skvitae_tempa_coffin {vc} {r} {-1ex} {0pt}
  \__skvitae_typeset_name_to_coffin:N\g__skvitae_tempa_coffin
  \coffin_join:NnnNnnnn \g__skvitae_tempa_coffin {T} {r}
                        \g__skvitae_tempb_coffin {T} {l} {2ex} {0pt}
  \vcoffin_set:Nnn \l_tmpa_coffin {\textwidth} { \strut }
  \coffin_join:NnnNnnnn \l_tmpa_coffin {t} {r} \g__skvitae_tempa_coffin {t} {r} {0pt} {0pt}
  \coffin_typeset:Nnnnn \l_tmpa_coffin {t} {l} {0pt} {0pt}
  \par
}

% Hacking the itemize environment
\RequirePackage{enumitem}
\setlist[itemize,1]{leftmargin=0pt, itemindent=0pt, label={}, itemsep=0pt}

% Helper
\DeclareExpandableDocumentCommand\and{}{
  {\itshape \&}
}
