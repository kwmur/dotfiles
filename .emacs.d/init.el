;;;; -*- coding: utf-8; lexical-binding: t -*-

;;; Emacs 23より前のバージョンを利用している場合
;;; user-emacs-directory変数が未定義のため次の設定を追加
(when (< emacs-major-version 23)
  (defvar user-emacs-directory "~/.emacs.d/"))

;;; load-path を追加
(defun add-to-load-path (&rest paths)
  (dolist (path paths)
    (let ((default-directory (expand-file-name (concat user-emacs-directory path))))
      (add-to-list 'load-path default-directory)
      (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
          (normal-top-level-add-subdirs-to-load-path)))))

;; load-pathへ追加 (サブディレクトリを含む)
(add-to-load-path "elisp" "conf" "public-repos")



;;; Emacs Lisp Package Archive (ELPA)
;;; package.el settings
;;; M-x list-packages
(when (require 'package nil t)
  ;; パッケージリポジトリにMarmalade,Melpa,開発者運営のELPAを追加
  (add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
  (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
  (add-to-list 'package-archives '("tromey-elpa" . "http://tromey.com/elpa/"))
  ;; インストールしたパッケージにロードパスを通して読み込む
  (package-initialize))



(init-loader-load "~/.emacs.d/conf")



;; インストールディレクトリを設定する 初期値は ~/.emacs.d/auto-install/
(setq auto-install-directory "~/.emacs.d/elisp/")
;; 必要であればプロキシの設定を行う
;; (setq url-proxy-services '(("http" . "localhost:8339")))
;; install-elisp の関数を利用可能にする
;(auto-install-compatibility-setup)
;; EmacsWikiに登録されているelispの名前を取得する
;(auto-install-update-emacswiki-package-name t) ; EmacsWikiに接続出来ない場合、起動時に固まる



;;; use common lisp
(require 'cl)



(require 'generic-x)



;;; keyboard settings
;; swap newline
(define-key global-map (kbd "C-m") 'newline-and-indent)
(define-key global-map (kbd "C-j") 'newline)

;; backspace
(define-key global-map (kbd "C-h") 'backward-delete-char-untabify)

;; 別のキーバインドにヘルプを割り当てる
(define-key global-map (kbd "C-c h") 'help-command)

;; 折り返しトグルコマンド
(define-key global-map (kbd "C-c l") 'toggle-truncate-lines)



;;; coding systems settings
;;; 文字コードを指定する
(set-language-environment "Japanese")
(prefer-coding-system 'utf-8)

;; Mac OS Xの場合のファイル名の設定
(when (eq system-type 'darwin)
  (require 'ucs-normalize)
  (set-file-name-coding-system 'utf-8-hfs)
  (setq lacale-coding-system 'utf-8-hfs))

;; Windowsの場合のファイル名、文字コードの設定
(when (eq window-system 'w32)
  (set-file-name-coding-system 'cp932)
  (setq locale-coding-system 'cp932)
  ;;(set-default-coding-systems 'cp932)
  )


;; マウスで選択するとコピーする Emacs 24 ではデフォルトが nil
(setq mouse-drag-copy-region t)



;;; editing settings
(setq scroll-step 3)



;;; display settings
(when window-system
  (tool-bar-mode 0)
  (scroll-bar-mode 0))

;; 'ns is CocoaEmacs
(unless (eq window-system 'ns)
  (menu-bar-mode 0))

;; Emacsの初期画面を表示しない
;; (setq inhibit-startup-screen t)

;; display column number
(column-number-mode t)

;; display file size
(size-indication-mode t)

;; display clock
(setq display-time-day-and-date t) ; day of week, month, day
(setq display-time-24hr-format t) ; display 24h
(display-time-mode t)

;; display battery only mobile PC
;; (display-battery-mode t)

;; display file path on title bar
(setq frame-title-format "%f")

;; display line number
(global-linum-mode t)



;;; tab character setting
;; tab width
(setq-default tab-width 4)

;; no use indent tab character
(setq-default indent-tabs-mode nil)



;;; リージョン内の行数と文字数をモードラインに表示する（範囲指定時のみ）
;;; http://d.hatena.ne.jp/sonota88/20110224/1298557375
(defun count-lines-and-chars ()
  (if mark-active
      (format "%d lines,%d chars "
              (count-lines (region-beginning) (region-end))
              (- (region-end) (region-beginning)))
      ;;(count-lines-region (region-beginning) (region-end)) ;; これだとエコーエリアがチラつく
    ""))

(add-to-list 'default-mode-line-format
             '(:eval (count-lines-and-chars)))



;;; color theme settings
;;; color-theme homepage - http://www.nongnu.org/color-theme/
;;; GNU Emacs Color Theme Test - http://code.google.com/p/gnuemacscolorthemetest/
(when (require 'color-theme nil t)
  ;; テーマを読み込むための設定
  (color-theme-initialize)
  (color-theme-hober)) ; テーマhoberに変更する
  ;(color-theme-taylo)) ; テーマTaylorに変更する Anything使用時に色がおかしい
  ;(color-theme-robin-hood))

(when (eq system-type 'darwin)
  ())


;;; current line highlite
(defface my-hl-line-face
  ;; 背景がdarkならば背景色を紺に表示
  '((((class color) (background dark))
     (:background "NavyBlue" t))
    ;; 背景がlightならば背景色を緑に表示
    (((class color) (background light))
     (:background "LightGoldenrodYellow" t))
    (t (:bold t)))
  "hl-line's my face")
;(setq hl-line-face 'my-hl-line-face)
;(global-hl-line-mode t)



;;; current paren highlite
;; paren-mode : 対応する括弧を強調して表示
(setq show-paren-delay 0) ; 表示までの秒数。初期値は0.125
(show-paren-mode t) ; 有効化

;; parenのスタイル
;; 一番上は対応する括弧だけをハイライト
;; 真ん中は括弧で囲まれた部分をハイライト
;; 一番下は画面内に対応する括弧がある場合は括弧だけを，ない場合は括弧で囲まれた部分をハイライト
;; http://keisanbutsuriya.blog.fc2.com/blog-category-2.html
(setq show-paren-style 'parenthesis) 
;(setq show-paren-style 'expression) 
;(setq show-paren-style 'mixed) 

;; set paren face
(set-face-background 'show-paren-match-face "darkgreen")
(set-face-underline-p 'show-paren-match-face nil)
(set-face-bold-p 'show-paren-match-face t)

;; set regex face
(set-face-foreground 'font-lock-regexp-grouping-backslash "green3")
(set-face-foreground 'font-lock-regexp-grouping-construct "green")


;;; function name face setting
;(set-face-bold-p 'font-lock-function-name-face t) ; 関数名を太字にしたいが、上手くいかない
;(set-face-bold-p 'help-argument-name t)
;(set-face-bold-p 'eldoc-highlight-function-argument nil)



;;; hook settings
;;ファイルが #! から始まる場合、+xを付けて保存する
(add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)


;;; set emacs-lisp-mode hook
;; eldoc
(defun elisp-mode-hooks ()
  (when (require 'eldoc nil t)
    (setq eldoc-idle-delay 0.2)
    (setq eldoc-echo-area-use-multiline-p t)
    (turn-on-eldoc-mode)))

(add-hook 'emacs-lisp-mode-hook 'elisp-mode-hooks)



;;; programming language C settings
;; c set style
(add-hook 'c-mode-common-hook
          (lambda ()
            (c-set-style "gnu")))


;;; programming language PHP settings
(add-hook 'php-mode-hook
          (lambda ()
            ;; '+はc-basic-offsetの値を利用するという指定
            (c-set-offset 'arglist-intro '+)
            ;; 0はインデントなしという指定
            (c-set-offset 'arglist-close 0)))



;;; extention settings

;; redo+の設定
;  ;; C-' にリドゥを割り当てる
;  ;(global-set-key (kbd "C-'") 'redo)
;  ;; 日本語キーボードの場合 C-. などがよいかも
;  (global-set-key (kbd "C-c .") 'redo)



;;; Anything
;; (auto-install-batch "anything")
;(when (require 'anything nil t)
;  (setq
;   ;; 候補を表示するまでの時間。デフォルトは0.5
;   anything-idle-delay 0.2
;   ;; タイプして再描写するまでの時間。デフォルトは0.1
;   anything-input-idle-delay 0.2
;   ;; 候補の最大表示数。デフォルトは50
;   anything-candidate-number-limit 100
;   ;; 候補が多い時に体感速度を早くする
;   anything-quick-update t
;   ;; 候補選択ショートカットをアルファベットに
;   anything-enable-shortcuts 'alphabet)
;
;  (when (require 'anything-config nil t)
;    ;; root権限でアクションを実行するときのコマンド
;    ;; デフォルトは"su"
;    (setq anything-su-or-sudo "sudo"))
;
;  (require 'anything-match-plugin nil t)
;
;  (when (and (executable-find "cmigemo")
;             (require 'migemo nil t))
;    (require 'anything-migemo nil t))
;
;  (when (require 'anything-complete nil t)
;    ;; lispシンボルの補完候補の再検索時間
;    (anything-lisp-complete-symbol-set-timer 150))
;
;  (require 'anything-show-completion nil t)
;
;  (when (require 'auto-install nil t)
;    (require 'anything-auto-install nil t))
;
;  (when (require 'descbinds-anything nil t)
;    ;; describe-bindingsをAnythingに置き換える
;    (descbinds-anything-install)))
;
;;; anything-show-kill-ringを割り当て
;(define-key global-map (kbd "C-c y") 'anything-show-kill-ring)
;
;;; anything-c-moccur settings
;;; color-moccur.el
;(when (require 'anything-c-moccur nil t)
;  (setq
;   ;; anything-c-moccur用 `anything-idle-delay'
;   anything-c-moccur-anything-idle-delay 0.1
;   ;; バッファの情報をハイライトする
;   anything-c-moccur-higligt-info-line-flag t
;   ;; 現在選択中の候補の位置を他のWindowに表示する
;   anything-c-moccur-enable-auto-look-flag t
;   ;; 起動時にポイントの位置の単語を初期パターンにする
;   anything-c-moccur-enable-initial-pattern t)
;  ;; anything-c-moccur-occur-by-moccurを割り当て
;  (global-set-dey (kbd "C-c o") 'anything-c-moccur-occur-by-moccur))

;; anything-for-filesを割り当て
;(require 'anything-config)
(define-key global-map (kbd "C-c b") 'anything-for-files)



;;; Auto Complete Mode - http://cx4a.org/software/auto-complete/index.ja.html
;; auto-complete settings
(when (require 'auto-complete-config nil t)
  (ac-config-default))



;;; open-junk-file.el
(when (require 'open-junk-file)
  (global-set-key (kbd "C-c j") 'open-junk-file))



;;; lispxmp.el
;; (install-elisp-from-emacswiki "lispxmp.el")
(when (require 'lispxmp)
  (define-key emacs-lisp-mode-map (kbd "C-c e") 'lispxmp))



;;; paredit.el
;(when (require 'paredit)
;  (add-hook 'emacs-lisp-mode-hook 'enable-paredit-mode)
;  (add-hook 'lisp-interaction-mode-hook 'enable-paredit-mode)
;  (add-hook 'lisp-mode-hook 'enable-paredit-mode)
;  (add-hook 'ielm-mode-hook 'enable-paredit-mode))



;;; auto-async-byte-compile.el
;; (install-elisp-from-emacswiki "auto-async-byte-compile.el")
;(when (require 'auto-async-byte-compile)
;  (setq auto-async-byte-compile-exclude-files-regexp "/junk/")
;  (add-hook 'emacs-lisp-mode-hook 'enable-auto-async-byte-compile-mode))



;;; sdic-mode setting
(autoload 'sdic-describe-word "sdic" "英単語の意味を調べる" t nil)
(global-set-key  (kbd "C-c W") 'sdic-describe-word)
(autoload 'sdic-describe-word-at-point "sdic" "カーソルの位置の英単語の意味を調べる" t nil)
(global-set-key (kbd "C-c w") 'sdic-describe-word-at-point)
(setq sdic-disable-select-window t)



;;; SLIME
(when (require 'slime)
  ;; Clozure CLをデフォルトのCommon Lisp処理系に設定  
  (setq inferior-lisp-program "ccl")
  ;; SLIMEからの入力をUTF-8に設定  
  (setq slime-net-coding-system 'utf-8-unix)
  (slime-setup '(slime-repl)))



;;; ac-slime
(when (require 'ac-slime)
  (add-hook 'slime-mode-hook 'set-up-slime-ac)
  (add-hook 'slime-repl-mode-hook 'set-up-slime-ac))



;;; powin.el
(when (require 'popwin)
  ;; Apropos
  (push '("*slime-apropos*") popwin:special-display-config)
  ;; Macroexpand
  (push '("*slime-macroexpansion*") popwin:special-display-config)
  ;; Help
  (push '("*slime-description*") popwin:special-display-config)
  ;; Compilation
  (push '("*slime-compilation*" :noselect t) popwin:special-display-config)
  ;; Cross-reference
  (push '("*slime-xref*") popwin:special-display-config)
  ;; Debugger
  (push '(sldb-mode :stick t) popwin:special-display-config)
  ;; REPL
  (push '(slime-repl-mode) popwin:special-display-config)
  ;; Connections
  (push '(slime-connection-list-mode) popwin:special-display-config))



;;; cl-indent-patches.el
(when (require 'cl-indent-patches nil t)
  ;; emacs-lispのインデントと混同しないように
  (setq lisp-indent-function
        (lambda (&rest args)
          (apply (if (memq major-mode '(emacs-lisp-mode lisp-interaction-mode))
                     'lisp-indent-function
                     'common-lisp-indent-function)
                 args))))




;;;; 参考文献など
;;;; 出典 大竹 智也 著『Emacs実践入門』（株式会社技術評論者発行）
;;;; 出典 るびきち 著『Emacs Lisp テクニックバイブル』（株式会社技術評論者発行）

