" Define regions
"
" [[Wikilinks]]
syn region markdownWikiLink matchgroup=markdownLinkDelimiter start="\[\[" end="\]\]" contains=markdownUrl keepend oneline concealends

" Markdown links with conceal
syn region markdownLink matchgroup=markdownLinkDelimiter start="(" end=")" contains=markdownUrl keepend contained conceal

" Markdown link text with concealends
syn region markdownLinkText matchgroup=markdownLinkTextDelimiter start="!\=\[\%(\%(\_[^][]\|\[\_[^][]*\]\)*]\%( \=[[(]\)\)\@=" end="\]\%( \=[[(]\)\@=" nextgroup=markdownLink,markdownId skipwhite contains=@markdownInline,markdownLineStart concealends

" Allow Markdown links wrapped in single or double quotes (e.g. "[foo](bar)")
syn match markdownLinkQuoted /\v(['"])\zs\[[^]]+\]\([^)]*\)\ze\1/ contained nextgroup=markdownLink,markdownLinkText

" Checkboxes
"
" Empty/checked box
syntax match mdCheckboxUnchecked /\[\s*\]/ contained conceal cchar=□
syntax match mdCheckboxChecked   /\[x\]/    contained conceal cchar=✓

" Box with dash
syntax match mdCheckboxEmpty   /\[-\]/ contained conceal cchar=▤
"
" Box with forward slash
syntax match mdCheckboxPartial /\[\/\]/ contained conceal cchar=◩

" Region for a bullet line that includes a checkbox state plus any other markdown inline syntax
syntax region mdCheckboxLine start="^\s*[-+*]\s\+" end="$" keepend contains=mdCheckboxPartial,mdCheckboxEmpty,mdCheckboxChecked,mdCheckboxUnchecked,@markdownInline
