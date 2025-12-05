" ===========================================================================
" ОСНОВНЫЕ НАСТРОЙКИ
" ===========================================================================

set encoding=utf-8
scriptencoding utf-8

set number
set relativenumber
syntax on

" Отступы
set tabstop=2
set shiftwidth=2
set expandtab
set autoindent
set smartindent

" Производительность и UX
set updatetime=300          " Быстрый обновляемый CursorHold
set signcolumn=yes          " Фиксированная ширина для диагностики
set hidden                  " Позволяет переключаться между буферами без сохранения
set termguicolors           " Поддержка true color

" Безопасность и совместимость
set nobackup
set nowritebackup


" ===========================================================================
" ПЛАГИНЫ (Vim-Plug)
" ===========================================================================

call plug#begin()

" UI / Темы
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ayu-theme/ayu-vim'
Plug 'ryanoasis/vim-devicons'

" Навигация
Plug 'preservim/nerdtree'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" LSP / Интеллект
Plug 'neoclide/coc.nvim', { 'branch': 'release' }

" UX / Feedback
Plug 'folke/noice.nvim'
Plug 'MunifTanjim/nui.nvim'
Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }

" Терминал
Plug 'akinsho/toggleterm.nvim', { 'tag': '*' }

" Удобство
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'

call plug#end()


" ===========================================================================
" TOGGLETERM.NVIM
" ===========================================================================

lua << EOF
require("toggleterm").setup({
  direction = "float",
  open_mapping = [[<c-t>]],
  insert_mappings = true,
  terminal_mappings = true,
  persist_size = true,
  start_in_insert = true,
  float_opts = {
    border = "single",
    winblend = 0,
    highlights = {
      border = "Normal",
    }
  }
})
EOF

" Маппинги (альтернатива через vimscript, но Lua-конфиг выше лучше)
nnoremap <silent><c-t> <Cmd>exe v:count1 . "ToggleTerm"<CR>
inoremap <silent><c-t> <Esc><Cmd>exe v:count1 . "ToggleTerm"<CR>
autocmd TermEnter term://*toggleterm#* tnoremap <silent><c-t> <Cmd>exe v:count1 . "ToggleTerm"<CR>


" ===========================================================================
" NERDTREE
" ===========================================================================

let NERDTreeMinimalUI = 1
let NERDTreeIgnore = ['\.pyc$', '__pycache__', 'node_modules', '\.git']

nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n>     :NERDTree<CR>
nnoremap <S-e>     :NERDTreeToggle<CR>
nnoremap <C-f>     :NERDTreeFind<CR>


" ===========================================================================
" COC.NVIM — LSP / DIAGNOSTICS / COMPLETION
" ===========================================================================

" Автодополнение
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1] =~# '\s'
endfunction

if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Навигация по коду
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Документация
nnoremap <silent> K :call ShowDocumentation()<CR>
function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Подсветка при удержании курсора
autocmd CursorHold * silent call CocActionAsync('highlight')

" Переименование
nmap <leader>rn <Plug>(coc-rename)

" Форматирование
xmap <leader>f <Plug>(coc-format-selected)
nmap <leader>f <Plug>(coc-format-selected)
command! -nargs=0 Format :call CocActionAsync('format')
augroup coc_format
  autocmd!
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
augroup end

" Code Actions
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>ac <Plug>(coc-codeaction-cursor)
nmap <leader>as <Plug>(coc-codeaction-source)
nmap <leader>qf <Plug>(coc-fix-current)
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

" CodeLens
nmap <leader>cl <Plug>(coc-codelens-action)

" Text objects
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Прокрутка float-окон
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Selection range
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Команды
command! -nargs=? Fold :call CocAction('fold', <f-args>)
command! -nargs=0 OR   :call CocActionAsync('runCommand', 'editor.action.organizeImport')

" Statusline
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" CoCList
nnoremap <silent><nowait> <space>a :<C-u>CocList diagnostics<cr>
nnoremap <silent><nowait> <space>e :<C-u>CocList extensions<cr>
nnoremap <silent><nowait> <space>c :<C-u>CocList commands<cr>
nnoremap <silent><nowait> <space>o :<C-u>CocList outline<cr>
nnoremap <silent><nowait> <space>s :<C-u>CocList -I symbols<cr>
nnoremap <silent><nowait> <space>j :<C-u>CocNext<CR>
nnoremap <silent><nowait> <space>k :<C-u>CocPrev<CR>
nnoremap <silent><nowait> <space>p :<C-u>CocListResume<CR>


" ===========================================================================
" СЕССИИ (AUTOSAVE / AUTOLOAD)
" ===========================================================================

autocmd VimLeavePre * silent! mksession! ~/.vim_session.vim
autocmd VimEnter * nested if argc() == 0 && filereadable(expand('~/.vim_session.vim'))
  \ | source ~/.vim_session.vim | endif


" ===========================================================================
" ОСТАЛЬНОЕ
" ===========================================================================

" Rainbow parentheses (если у вас установлен плагин, например, 'junegunn/rainbow')
" let g:rainbow_active = 1

" Noice.nvim
lua require("noice").setup()

" ===========================================================================
" ЦВЕТОВАЯ СХЕМА
" ===========================================================================

let ayucolor = "dark"
colorscheme ayu
