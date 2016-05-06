;;; quiet.el --- disconnect from the online world for a while

;; Copyright 2016 FoAM vzw
;;
;; Author: nik gaffney <nik@fo.am>
;; Created: 2016-05-05
;; Version: 0.1
;; Keywords: quiet, distraction, network, detachment, offline
;; X-URL: https://github.com/zzkt/quiet

;; This file is not part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.


;;; Commentary:

;; disconnect from the online world for a while, possibly reconnecting later
;;
;; you may need to customize or setq quiet-disconnect and quiet-connect to
;; the appropriate shell commands to turn your network (interface) on or off
;;
;; MacOS
;;  % networksetup -setairportpower airport {on,off}
;; Linux 
;;  % ifup wlan0
;;  % ifdown wlan0
;; BSD
;;  % service netif {stop, start}

;;; Code:

(provide 'quiet)

(defcustom  quiet-disconnect "networksetup -setairportpower airport off"
  "Shell command to turn off network connection(s)"
  :type 'string
  :options '("networksetup -setairportpower airport off" "ifdown wlan0")
  :group 'quiet)

(defcustom  quiet-connect "networksetup -setairportpower airport on"
  "Shell command to turn on network connection(s)"
  :type 'string
  :options '("networksetup -setairportpower airport off" "ifup wlan0")
  :group 'quiet)

(defcustom  quiet-timer 0
  "Timer to reconnect network after a given time (in minutes). A value of 0 will leave the connection off"
  :type 'integer
  :group 'quiet)

;; M-x quiet
(defun quiet ()
  "quieten network distractions for a while..."
  (interactive)
  (save-window-excursion
    (message "disconnecting...")
    (async-shell-command quiet-disconnect))
  (if (not (= quiet-timer 0))
      (progn 
	(run-at-time (* quiet-timer 60) nil 'quiet-reconnect))))

(defun quiet-reconnect ()
  (interactive)
  (save-window-excursion
    (message "reconnecting after ~%d %s" quiet-timer (if (= quiet-timer 1) "minute" "minutes"))
    (async-shell-command quiet-connect)))

;;; quiet.el ends here
