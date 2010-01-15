;;; disk-usage.el --- show disk usage

;; Copyright (C) 2010  niels giesen

;; Author: niels giesen <sharik@matroshka>
;; Keywords: 

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Requires the UNIX "du" utility

;; Put something like the following in your init file (~/.emacs,
;; ~/.emacs.d/init.el or something similar):

;; (add-to-list 'load-path "~/.emacs.d/disk-usage")
;; (autoload 'du "disk-usage")

;;; Run with M-x du

;;; Customization is available under M-x customize-group du

;;; See function `du-mode' for more info.

;;; Code:

(defun du (dir &optional edit-args)
  "List disk usage in DIR.

With prefix arg EDIT-ARGS, let user to edit arguments given to du."
  (interactive 
   "DDirectory: \nP")
  (switch-to-buffer "*du*")
  (du-mode t)
  (let (buffer-read-only)
   (erase-buffer)
   (mapc
	#'du-insert
	(nreverse
	 (sort
	  (remove-if #'du-to-be-ignored-p
				 (split-string 
				  (shell-command-to-string
				   (format 
					"du %s %s 2>%s"
					(if edit-args 
						(read-from-minibuffer "Arguments: du " du-args)
					  du-args)
					(shell-quote-argument
					 (expand-file-name dir))
					du-err-log))
				  "\n" t))
	  #'du-compare)))
      (if (du-empty-buffer-p)
		  (insert-file-contents du-err-log)
		(delete-char -1)))
  (goto-char (point-min)))

(defun du-to-be-ignored-p (s)
   (<= (du-dehumanize-string s)
	  du-ignored-size))

(defcustom du-err-log "/tmp/du-err.log"
	"Error log file for du."
	:type '(file)
	:group 'du)

(defcustom du-ignored-size 1048576
  "Ignore files of or below this size."
  :group 'du
  :type '(number))

(defgroup du nil
  "Customization group for du (disk-usage)")

(defcustom du-args
  "--max-depth=1 -h -a"
  "Arguments to be given to du.

Allowed are:

	-a, --all
	--apparent-size
	-B, --block-size=SIZE
	-b, --bytes
	-c, --total
	-D, --dereference-args
	--files0-from=F
	-H   like --si, but also  evokes a warning; will soon change
	--si like -h, but use powers of 1000 not 1024
	-k   like --block-size=1K
	-l, --count-links
	-m   like --block-size=1M
	-L, --dereference
	-P, --no-dereference
	-S, --separate-dirs
	-s, --summarize
	-x, --one-file-system
	-X FILE, --exclude-from=FILE
	--exclude=PATTERN
	--max-depth=N

See man(du) for explanation of those arguments"
  :group 'du)

(defun du-size-part (s)
  (string-to-number s))

(defun du-dehumanize-string (s)
  (string-match 
   du-size-regex 
   s)
  (* (string-to-number
	(match-string 1 s))
	 (cdr (assoc 
		   (match-string 2 s)
		   du-size-alist))))

(defun du-compare (s1 s2)
  (< (du-dehumanize-string s1)
	 (du-dehumanize-string s2)))

(defun du-insert (s)
  (string-match 
   du-size-regex 
   s)
  (insert 
   (format 
	"% 10s%2s %s"
	(match-string 1 s)
	(match-string 2 s)
	(substring s (match-end 3)))
   ?\n))


(defvar du-sizes
  '(""
	""
	"kB"
	"K"
	"MB"
	"M"
	"G"
	"T"
	"P"
	"E"
	"Z"
	"Y"))

(defvar du-size-regex 
  (eval
   `(rx
	 string-start
	 (group 
	  (1+ (or digit ".")))
	 (group
	  (or
	   ,@du-sizes))
	 (group (1+ space))))
  "Regular epression matching file sizes")

(defvar du-inserted-string-regex 
  (eval
   `(rx
	 string-start
	 (1+ space)
	 (group 
	  (1+ (or digit ".")))
	 (1+ space)
	 (group
	  (or
	   ,@du-sizes))
	 (group (1+ space))))
  "Regular epression matching file sizes")

(defvar du-size-alist 
  (let (result)
	(dotimes (n (length du-sizes) result)
	  (push 
	   (cons 
		(nth n du-sizes)
		(expt (if (zerop (% n 2))
				  1000.0
				1024.0) 
			  (/  n 2)))
	   result)))
  "Following kB 1000, K 1024, MB 1000*1000, M 1024*1024, and so on for G, T, P, E, Z, Y")

(defun du-down-dir ()
  (interactive)
  (let* ((line (buffer-substring-no-properties
				(point-at-bol)
				(point-at-eol)))
		 (file-or-dir 
		  (progn
			(string-match du-inserted-string-regex line)
			(substring line (match-end 3)))))
	(if
	 (file-directory-p file-or-dir)
		(du file-or-dir)
	  (message 
	   "Not a directory: %s" file-or-dir))))

(defun du-up-dir ()
  "Go up a dir"
  (interactive)
  (let* ((line (buffer-substring-no-properties
				(point-at-bol)
				(point-at-eol)))
		 (file-or-dir 
		  (progn
			(string-match du-inserted-string-regex line)
			(substring line (match-end 3)))))
	(du
	 (file-name-directory 
	  (substring file-or-dir
				 0 -1)))))

(defvar du-map
  (let ((m (make-sparse-keymap)))
	(define-key m "\C-m" 'du-down-dir)
	(define-key m [(:)] 'du-up-dir)
	(define-key m [(d)] 'du-dired)
	(define-key m [(q)] 'bury-buffer)
	m))

(defun du-dired ()
  "View dir in dired"
  (interactive)
  (let* ((line (buffer-substring-no-properties
				(point-at-bol)
				(point-at-eol)))
		 (file-or-dir 
		  (progn
			(string-match du-inserted-string-regex line)
			(substring line (match-end 3)))))
	(dired
	 (if (file-directory-p file-or-dir)
		 file-or-dir
	   (file-name-directory file-or-dir)))))

(defun du-empty-buffer-p ()
 (= (point-min)
	(point-max)))

(define-minor-mode du-mode 
  "Minor mode for du.

Du shows disk usage and allows navigation and switching to dired.

Key bindings:

 \\{du-map}"
  nil
  " du"
  du-map
  (setq buffer-read-only t))

(provide 'disk-usage)
;;; disk-usage.el ends here
