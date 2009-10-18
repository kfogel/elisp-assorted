;;; nyquist.el --- 

;; Copyright (C) 2007  Niels Giesen

;; Author: Niels Giesen <com dot gmail at niels dot giesen, in reversed order>
;; Keywords: lisp, multimedia, tools, docs

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 3
;; of the License, or (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
;; 02111-1307, USA.

;;; Commentary:
;; Some interfaces for interacting interacting with the nyquist interpreter (which
;; simply should be run with the function `run-lisp')

;; And two documentation functions: `ny-lookup' and `ny-info'

;; Put something like this in your .emacs:

;; (autoload 'ny "nyquist" "Run nyquist in inferior lisp shell" t)

;;; Code:
(defgroup nyquist nil "Customization group for nyquist.el"
  :group 'multimedia)

(defcustom ny-doc-root "file:///usr/share/doc/nyquist/doc/"
  "Root for nyquist documentation"
  :group 'nyquist)

(defcustom ny-startup-string nil
  "Startup string for nyquist process."
  :group 'nyquist
  :type '(choice string (boolean nil)))

(defvar ny-lookup-history nil "History ring of looked-up nyquist documentation")

(defvar ny-doc-list 
      '(("#define'd macros" "part11.html#index486" )
        ("*" "part12.html#index690" )
        ("*a4-hertz*" "part6.html#index146" )
        ("*applyhook*" "part12.html#index529" )
        ("*breakenable*" "part12.html#index491"  "part12.html#index494"  "part12.html#index524" )
        ("*control-srate*" "part3.html#index69"  "part6.html#index302" )
        ("*debug-io*" "part12.html#index523" )
        ("*default-plot-file*" "part6.html#index365" )
        ("*default-sf-dir*" "part6.html#index339" )
        ("*default-sf-srate*" "part6.html#index354" )
        ("*error-output*" "part12.html#index521" )
        ("*evalhook*" "part12.html#index528" )
        ("*float-format*" "part12.html#index535" )
        ("*gc-flag*" "part12.html#index532" )
        ("*gc-hook*" "part12.html#index533" )
        ("*integer-format*" "part12.html#index534" )
        ("*loud*" "part3.html#index64" )
        ("*obarray*" "part12.html#index518" )
        ("*plotscript-file*" "part6.html#index366" )
        ("*print-case*" "part12.html#index536" )
        ("*readtable*" "part12.html#index502"  "part12.html#index530" )
        ("*rslt*" "part11.html#index485" )
        ("*sound-srate*" "part3.html#index70"  "part6.html#index308" )
        ("*standard-input*" "part12.html#index519" )
        ("*standard-output*" "part12.html#index520" )
        ("*start*" "part3.html#index67" )
        ("*stop*" "part3.html#index68" )
        ("*sustain*" "part3.html#index66" )
        ("*trace-output*" "part12.html#index522" )
        ("*tracelimit*" "part12.html#index493"  "part12.html#index527" )
        ("*tracelist*" "part12.html#index525" )
        ("*tracenable*" "part12.html#index492"  "part12.html#index526" )
        ("*transpose*" "part3.html#index65" )
        ("*unbound*" "part12.html#index531" )
        ("*warp*" "part3.html#index63"  "part6.html#index296"  "part6.html#index298" )
        ("+" "part12.html#index688" )
        ("-" "part12.html#index689" )
        ("/" "part12.html#index691" )
        ("/=" "part12.html#index713" )
        ("1+" "part12.html#index692" )
        ("1-" "part12.html#index693" )
        (":answer" "part12.html#index515" )
        (":class" "part12.html#index508" )
        (":isnew" "part12.html#index509"  "part12.html#index514" )
        (":new" "part12.html#index513" )
        (":sendsuper" "part12.html#index510" )
        (":show" "part12.html#index507" )
        ("<" "part12.html#index710" )
        ("<=" "part12.html#index711" )
        ("=" "part12.html#index712" )
        (">" "part12.html#index715" )
        (">=" "part12.html#index714" )
        ("a440" "part6.html#index145" )
        ("abs" "part12.html#index701" )
        ("abs-env" "part6.html#index294" )
        ("absolute value" "part6.html#index271"  "part6.html#index384" )
        ("access samples" "part6.html#index110" )
        ("add offset to sound" "part6.html#index390" )
        ("add to file samples" "part6.html#index356" )
        ("address-of" "part12.html#index813" )
        ("all pass filter" "part6.html#index224" )
        ("alloc" "part12.html#index808" )
        ("allpass2" "part6.html#index254" )
        ("alpass filter" "part6.html#index225" )
        ("amosc" "part6.html#index194" )
        ("and" "part12.html#index637" )
        ("append" "part12.html#index584" )
        ("apply" "part12.html#index539" )
        ("approximation" "part6.html#index205" )
        ("aref" "part12.html#index568" )
        ("areson" "part6.html#index243" )
        ("arithmetic functions" "part12.html#index685" )
        ("array from sound" "part6.html#index122" )
        ("array functions" "part12.html#index567" )
        ("arrayp" "part12.html#index622" )
        ("assoc" "part12.html#index588" )
        ("at" "part6.html#index295"  "part6.html#index297" )
        ("at transformation" "part3.html#index74" )
        ("atom" "part12.html#index610" )
        ("atone" "part6.html#index240" )
        ("autonorm-off" "part5.html#index91"  "part6.html#index340"  "part6.html#index345" )
        ("autonorm-on" "part5.html#index92"  "part6.html#index341"  "part6.html#index344" )
        ("average" "part6.html#index394" )
        ("backquote" "part12.html#index543" )
        ("baktrace" "part12.html#index680" )
        ("bandpass filter" "part6.html#index242" )
        ("bandpass2" "part6.html#index252" )
        ("behavioral abstraction" "part3.html#index59" )
        ("behaviors" "part6.html#index148" )
        ("binary files" "part12.html#index784" )
        ("biquad" "part6.html#index248" )
        ("biquad-m" "part6.html#index249" )
        ("bitwise logical functions" "part12.html#index716" )
        ("block" "part12.html#index660" )
        ("both-case-p" "part12.html#index749" )
        ("boundp" "part2.html#index11"  "part12.html#index625" )
        ("break" "part12.html#index490"  "part12.html#index675" )
        ("build-harmonic" "part2.html#index8"  "part6.html#index165" )
        ("buzz" "part6.html#index196" )
        ("car" "part12.html#index572" )
        ("case" "part12.html#index642" )
        ("catch" "part12.html#index648" )
        ("cdr" "part12.html#index573" )
        ("cerror" "part12.html#index674" )
        ("char" "part12.html#index746" )
        ("char-code" "part12.html#index751" )
        ("char-downcase" "part12.html#index754" )
        ("char-equalp" "part12.html#index766" )
        ("char-greaterp" "part12.html#index769" )
        ("char-int" "part12.html#index756" )
        ("char-lessp" "part12.html#index764" )
        ("char-not-equalp" "part12.html#index767" )
        ("char-not-greaterp" "part12.html#index765" )
        ("char-not-lessp" "part12.html#index768" )
        ("char-upcase" "part12.html#index753" )
        ("char/=" "part12.html#index761" )
        ("char<" "part12.html#index758" )
        ("char<=" "part12.html#index759" )
        ("char=" "part12.html#index760" )
        ("char>" "part12.html#index763" )
        ("char>=" "part12.html#index762" )
        ("character functions" "part12.html#index745" )
        ("characterp" "part12.html#index621" )
        ("chorus" "part6.html#index404" )
        ("class" "part12.html#index512" )
        ("class class" "part12.html#index511" )
        ("clean-up" "part12.html#index676" )
        ("clip" "part5.html#index86"  "part6.html#index267"  "part6.html#index268"  "part6.html#index395" )
        ("close" "part12.html#index785" )
        ("co-termination" "part6.html#index380" )
        ("code-char" "part12.html#index752" )
        ("comb filter" "part6.html#index226" )
        ("combination" "part6.html#index320" )
        ("command loop" "part12.html#index489" )
        ("compose" "part6.html#index397" )
        ("compressor" "part6.html#index412" )
        ("concatenate strings" "part12.html#index732" )
        ("cond" "part12.html#index636" )
        ("congen" "part6.html#index227" )
        ("cons" "part12.html#index582" )
        ("consp" "part12.html#index617" )
        ("const" "part6.html#index153" )
        ("constant function" "part6.html#index154" )
        ("continue" "part12.html#index678" )
        ("continuous-control-warp" "part6.html#index299" )
        ("continuous-sound-warp" "part6.html#index300" )
        ("contour generator" "part6.html#index228" )
        ("control" "part6.html#index152" )
        ("control constructs" "part12.html#index635" )
        ("control-srate-abs" "part6.html#index301" )
        ("control-warp" "part6.html#index166" )
        ("convert sound to array" "part6.html#index123" )
        ("convolution" "part6.html#index230" )
        ("cos" "part12.html#index705" )
        ("cue" "part6.html#index149" )
        ("cue-file" "part6.html#index150" )
        ("cxxr" "part12.html#index574" )
        ("cxxxr" "part12.html#index575" )
        ("cxxxxr" "part12.html#index576" )
        ("data types" "part12.html#index496" )
        ("db-to-linear" "part6.html#index135" )
        ("db0" "part2.html#index32" )
        ("db1" "part2.html#index33" )
        ("db10" "part2.html#index34" )
        ("debugging" "part6.html#index128"  "part6.html#index368"  "part9.html#index481"  "part12.html#index669"  "part12.html#index681" )
        ("default sample rate" "part3.html#index78" )
        ("default sound file directory" "part6.html#index338" )
        ("defining behaviors" "part3.html#index76" )
        ("defmacro" "part12.html#index554" )
        ("defun" "part12.html#index553" )
        ("delay" "part6.html#index233" )
        ("delay, variable" "part6.html#index403" )
        ("delete" "part12.html#index605" )
        ("delete-if" "part12.html#index606" )
        ("delete-if-not" "part12.html#index607" )
        ("derivative" "part6.html#index181" )
        ("destructive list functions" "part12.html#index601" )
        ("diff" "part6.html#index329" )
        ("difference of sounds" "part6.html#index330" )
        ("digit-char" "part12.html#index755" )
        ("digit-char-p" "part12.html#index750" )
        ("directory, default sound file" "part6.html#index337" )
        ("division" "part6.html#index289" )
        ("do" "part12.html#index653" )
        ("do*" "part12.html#index654" )
        ("dolist" "part12.html#index655" )
        ("dotimes" "part12.html#index656" )
        ("dotted durations" "part2.html#index51" )
        ("dribble" "part12.html#index805" )
        ("dubugging" "part6.html#index406" )
        ("duration notation" "part2.html#index35" )
        ("duration of another sound" "part6.html#index381" )
        ("echo" "part6.html#index234" )
        ("eighth note" "part2.html#index39" )
        ("emacs, using nyquist with" "part12.html#index817" )
        ("endp" "part12.html#index616" )
        ("env" "part2.html#index22"  "part6.html#index155" )
        ("env-note" "part2.html#index21" )
        ("envelope" "part2.html#index19" )
        ("envelope follower" "part6.html#index411" )
        ("envelope generator" "part6.html#index229" )
        ("envelopes" "part2.html#index18" )
        ("environment" "part3.html#index62" )
        ("eq" "part12.html#index632" )
        ("eq-band" "part6.html#index259" )
        ("eq-highshelf" "part6.html#index257" )
        ("eq-lowshelf" "part6.html#index255" )
        ("eql" "part12.html#index633" )
        ("equal" "part12.html#index634" )
        ("equalization" "part6.html#index256"  "part6.html#index258"  "part6.html#index260" )
        ("error" "part12.html#index673" )
        ("error handling" "part12.html#index670" )
        ("errors" "part1.html#index2" )
        ("errset" "part12.html#index679" )
        ("eval" "part12.html#index538" )
        ("evalhook" "part12.html#index683" )
        ("evaluation functions" "part12.html#index537" )
        ("evaluator" "part12.html#index497" )
        ("evenp" "part12.html#index630" )
        ("exit" "part12.html#index814" )
        ("exp" "part12.html#index708" )
        ("exp-dec" "part6.html#index156" )
        ("expand" "part12.html#index807" )
        ("exponential" "part6.html#index275" )
        ("exponential envelope" "part6.html#index157" )
        ("expt" "part12.html#index707" )
        ("extending xlisp" "part11.html#index483" )
        ("extract" "part6.html#index303"  "part6.html#index304" )
        ("fboundp" "part12.html#index626" )
        ("feedback-delay" "part6.html#index232" )
        ("fft" "part8.html#index477" )
        ("file i/o functions" "part12.html#index781"  "part12.html#index818" )
        ("fir filter" "part6.html#index231" )
        ("first" "part12.html#index577" )
        ("first derivative" "part6.html#index182" )
        ("flatc" "part12.html#index778" )
        ("flatsize" "part12.html#index777" )
        ("flet" "part12.html#index645" )
        ("float" "part12.html#index687" )
        ("floatp" "part12.html#index619" )
        ("fmlfo" "part6.html#index163" )
        ("fmosc" "part6.html#index195" )
        ("follower" "part6.html#index410" )
        ("force-srate" "part6.html#index158" )
        ("format" "part12.html#index780" )
        ("fourth" "part12.html#index580" )
        ("frequency modulation" "part5.html#index93" )
        ("funcall" "part12.html#index540" )
        ("function" "part12.html#index542" )
        ("gate" "part6.html#index416" )
        ("gc" "part12.html#index806" )
        ("gcd" "part12.html#index702" )
        ("gen05" "part6.html#index221" )
        ("gensym" "part12.html#index555" )
        ("get" "part12.html#index564" )
        ("get-duration" "part6.html#index369" )
        ("get-lambda-expression" "part12.html#index545" )
        ("get-loud" "part6.html#index370" )
        ("get-output-stream-list" "part12.html#index800" )
        ("get-output-stream-string" "part12.html#index799" )
        ("get-sustain" "part6.html#index371" )
        ("get-transpose" "part6.html#index372" )
        ("get-warp" "part6.html#index373" )
        ("global variables" "part7.html#index475" )
        ("go" "part12.html#index664" )
        ("h" "part2.html#index42" )
        ("half note" "part2.html#index43" )
        ("hash" "part12.html#index562" )
        ("hd" "part2.html#index49" )
        ("header file format" "part11.html#index484" )
        ("high-pass filter" "part6.html#index239" )
        ("highpass2" "part6.html#index251" )
        ("highpass4" "part6.html#index264" )
        ("highpass6" "part6.html#index265" )
        ("highpass8" "part6.html#index266" )
        ("hp" "part6.html#index238" )
        ("ht" "part2.html#index55" )
        ("hz-to-step" "part6.html#index136" )
        ("hzosc" "part6.html#index186" )
        ("i" "part2.html#index38" )
        ("id" "part2.html#index47" )
        ("if" "part12.html#index639" )
        ("ifft" "part8.html#index479" )
        ("input from a file" "part12.html#index819" )
        ("input/output functions" "part12.html#index770" )
        ("int-char" "part12.html#index757" )
        ("integerp" "part12.html#index618" )
        ("integrate" "part6.html#index178" )
        ("intern" "part12.html#index556" )
        ("intgen" "part11.html#index482" )
        ("inverse" "part6.html#index417" )
        ("inverse fft" "part8.html#index480" )
        ("it" "part2.html#index53" )
        ("karplus-strong" "part6.html#index198" )
        ("labels" "part12.html#index646" )
        ("lambda" "part12.html#index544" )
        ("lambda lists" "part12.html#index503" )
        ("last" "part12.html#index586" )
        ("legato" "part6.html#index312" )
        ("length" "part12.html#index592" )
        ("let" "part12.html#index643" )
        ("let*" "part12.html#index644" )
        ("lexical conventions" "part12.html#index499" )
        ("lf" "part2.html#index29" )
        ("lff" "part2.html#index30" )
        ("lfff" "part2.html#index31" )
        ("lfo" "part6.html#index161" )
        ("limit" "part6.html#index269" )
        ("limiter" "part6.html#index413" )
        ("linear-to-db" "part6.html#index137" )
        ("lisp include files" "part11.html#index487" )
        ("list" "part12.html#index583" )
        ("list functions" "part12.html#index571" )
        ("listp" "part12.html#index615" )
        ("lmf" "part2.html#index28" )
        ("lmp" "part2.html#index27" )
        ("load" "part12.html#index802" )
        ("local-to-global" "part6.html#index374" )
        ("log function" "part6.html#index138" )
        ("logand" "part12.html#index717" )
        ("logical-stop" "part6.html#index99" )
        ("logior" "part12.html#index718" )
        ("lognot" "part12.html#index720" )
        ("logorithm" "part6.html#index277" )
        ("logxor" "part12.html#index719" )
        ("loop" "part12.html#index652" )
        ("looping constructs" "part12.html#index651" )
        ("loud" "part6.html#index305"  "part6.html#index306" )
        ("low-frequency oscillator" "part6.html#index162" )
        ("low-pass filter" "part6.html#index236"  "part6.html#index463" )
        ("lower-case-p" "part12.html#index748" )
        ("lowpass2" "part6.html#index250" )
        ("lowpass4" "part6.html#index261" )
        ("lowpass6" "part6.html#index262" )
        ("lowpass8" "part6.html#index263" )
        ("lp" "part2.html#index26"  "part6.html#index235" )
        ("lpp" "part2.html#index25" )
        ("lppp" "part2.html#index24" )
        ("macroexpand" "part12.html#index546" )
        ("macroexpand-1" "part12.html#index547" )
        ("macrolet" "part12.html#index647" )
        ("make-array" "part12.html#index569" )
        ("make-string-input-stream" "part12.html#index797" )
        ("make-string-output-stream" "part12.html#index798" )
        ("make-symbol" "part12.html#index557" )
        ("maketable" "part6.html#index164" )
        ("mapc" "part12.html#index595" )
        ("mapcar" "part12.html#index596" )
        ("mapl" "part12.html#index597" )
        ("maplist" "part12.html#index598" )
        ("max" "part12.html#index699" )
        ("maximum" "part6.html#index280"  "part12.html#index700" )
        ("maximum amplitude" "part5.html#index85"  "part6.html#index422" )
        ("maximum of two sounds" "part6.html#index424" )
        ("member" "part12.html#index587" )
        ("memory usage" "part6.html#index133" )
        ("min" "part12.html#index697" )
        ("minimum" "part6.html#index282"  "part12.html#index698" )
        ("minusp" "part12.html#index627" )
        ("mix" "part6.html#index328" )
        ("mix to file" "part6.html#index357" )
        ("mkwave" "part2.html#index7" )
        ("modulo (rem) function" "part12.html#index696" )
        ("moving average" "part6.html#index392" )
        ("mult" "part2.html#index20"  "part6.html#index167" )
        ("multichannel sounds" "part6.html#index100" )
        ("multiplication" "part6.html#index428" )
        ("natural log" "part6.html#index278" )
        ("nconc" "part12.html#index604" )
        ("nested transformations" "part3.html#index75" )
        ("noise" "part6.html#index292" )
        ("noise gate" "part6.html#index415" )
        ("normalization" "part5.html#index83" )
        ("not" "part12.html#index614" )
        ("not enough memory for normalization" "part5.html#index90" )
        ("notch filter" "part6.html#index244" )
        ("notch2" "part6.html#index253" )
        ("note" "part2.html#index17" )
        ("note list" "part6.html#index333" )
        ("nstring-downcase" "part12.html#index730" )
        ("nstring-upcase" "part12.html#index729" )
        ("nth" "part12.html#index593" )
        ("nthcdr" "part12.html#index594" )
        ("null" "part12.html#index613" )
        ("numberp" "part12.html#index612" )
        ("object" "part12.html#index506" )
        ("object class" "part12.html#index505" )
        ("objectp" "part12.html#index624" )
        ("objects" "part12.html#index504" )
        ("oddp" "part12.html#index631" )
        ("offset to a sound" "part6.html#index389" )
        ("omissions" "part1.html#index3" )
        ("open" "part12.html#index782"  "part12.html#index783" )
        ("or" "part12.html#index638" )
        ("osc" "part2.html#index5"  "part6.html#index183" )
        ("osc-note" "part6.html#index283" )
        ("osc-pulse" "part6.html#index191" )
        ("osc-saw" "part6.html#index187" )
        ("osc-tri" "part6.html#index189" )
        ("output samples to file" "part6.html#index351" )
        ("output to a file" "part12.html#index820" )
        ("overlap" "part6.html#index313" )
        ("overwrite samples" "part6.html#index360" )
        ("pan" "part6.html#index169" )
        ("partial" "part6.html#index184" )
        ("peak amplitude" "part5.html#index84" )
        ("peak, maximum amplitude" "part6.html#index420" )
        ("peek" "part12.html#index811" )
        ("peek-char" "part12.html#index787" )
        ("piece-wise" "part6.html#index204" )
        ("piece-wise linear" "part6.html#index430" )
        ("pitch notation" "part2.html#index58" )
        ("play" "part2.html#index6"  "part6.html#index335" )
        ("pluck" "part6.html#index197" )
        ("plucked string" "part6.html#index200" )
        ("plusp" "part12.html#index629" )
        ("poke" "part12.html#index812" )
        ("pprint" "part12.html#index775" )
        ("predicate functions" "part12.html#index609" )
        ("prin1" "part12.html#index773" )
        ("princ" "part12.html#index774" )
        ("print" "part12.html#index772" )
        ("prod" "part6.html#index168"  "part6.html#index171" )
        ("profile" "part12.html#index684" )
        ("profiling" "part12.html#index516" )
        ("prog" "part12.html#index658" )
        ("prog*" "part12.html#index659" )
        ("prog1" "part12.html#index666" )
        ("prog2" "part12.html#index667" )
        ("progn" "part12.html#index668" )
        ("progv" "part12.html#index665" )
        ("property list functions" "part12.html#index563" )
        ("psetq" "part12.html#index551" )
        ("pulse oscillator" "part6.html#index192" )
        ("pulse-width modulation" "part6.html#index193" )
        ("putprop" "part12.html#index565" )
        ("pwe" "part6.html#index215" )
        ("pwe-list" "part6.html#index216" )
        ("pwer" "part6.html#index219" )
        ("pwer-list" "part6.html#index220" )
        ("pwev" "part6.html#index217" )
        ("pwev-list" "part6.html#index218" )
        ("pwevr" "part6.html#index222" )
        ("pwevr-list" "part6.html#index223" )
        ("pwl" "part6.html#index207" )
        ("pwl-list" "part6.html#index208" )
        ("pwlr" "part6.html#index211" )
        ("pwlr-list" "part6.html#index212" )
        ("pwlv" "part6.html#index209" )
        ("pwlv-list" "part6.html#index210" )
        ("pwlvr" "part6.html#index213" )
        ("pwlvr-list" "part6.html#index214" )
        ("q" "part2.html#index40" )
        ("qd" "part2.html#index48" )
        ("qt" "part2.html#index54" )
        ("quantize" "part6.html#index284" )
        ("quarter note" "part2.html#index41" )
        ("quote" "part12.html#index541" )
        ("ramp" "part6.html#index285" )
        ("random" "part12.html#index703" )
        ("read" "part12.html#index771" )
        ("read samples" "part6.html#index113" )
        ("read samples from file" "part6.html#index353" )
        ("read-byte" "part12.html#index794" )
        ("read-char" "part12.html#index786" )
        ("read-float" "part12.html#index791" )
        ("read-int" "part12.html#index789" )
        ("read-line" "part12.html#index793" )
        ("readtables" "part12.html#index501" )
        ("recip" "part6.html#index287" )
        ("reciprocal" "part6.html#index288" )
        ("rem" "part12.html#index694" )
        ("remainder" "part12.html#index695" )
        ("remove" "part12.html#index589" )
        ("remove-if" "part12.html#index590" )
        ("remove-if-not" "part12.html#index591" )
        ("remprop" "part12.html#index566" )
        ("replace file samples" "part6.html#index359" )
        ("resample" "part6.html#index172" )
        ("resampling" "part6.html#index160" )
        ("rescaling" "part5.html#index89" )
        ("reson" "part6.html#index241" )
        ("rest" "part6.html#index290"  "part12.html#index581" )
        ("restore" "part12.html#index804" )
        ("return" "part12.html#index661" )
        ("return-from" "part12.html#index662" )
        ("reverse" "part12.html#index585" )
        ("rms" "part6.html#index286"  "part6.html#index393" )
        ("room" "part12.html#index809" )
        ("rplaca" "part12.html#index602" )
        ("rplacd" "part12.html#index603" )
        ("s" "part2.html#index36" )
        ("s-abs" "part6.html#index270" )
        ("s-add-to" "part6.html#index355" )
        ("s-exp" "part6.html#index274" )
        ("s-log" "part6.html#index276" )
        ("s-max" "part5.html#index87"  "part6.html#index279" )
        ("s-min" "part5.html#index88"  "part6.html#index281" )
        ("s-overwrite" "part6.html#index358" )
        ("s-plot" "part6.html#index364" )
        ("s-read" "part6.html#index352" )
        ("s-rest" "part6.html#index291" )
        ("s-save" "part6.html#index348" )
        ("s-sqrt" "part6.html#index272" )
        ("sample interpolation" "part6.html#index434"  "part6.html#index436" )
        ("sample rate, forcing" "part6.html#index159" )
        ("sample rates" "part3.html#index77" )
        ("sampler" "part6.html#index203" )
        ("samples" "part6.html#index96"  "part6.html#index120" )
        ("samples, reading" "part6.html#index111" )
        ("sampling rate" "part6.html#index140"  "part6.html#index142" )
        ("save" "part12.html#index803" )
        ("save samples to file" "part6.html#index349" )
        ("saving sound files" "part5.html#index82" )
        ("sawtooth oscillator" "part6.html#index188" )
        ("sawtooth wave" "part2.html#index15" )
        ("scale" "part2.html#index9"  "part6.html#index173" )
        ("scale-db" "part6.html#index174" )
        ("scale-srate" "part6.html#index175" )
        ("score" "part6.html#index332" )
        ("sd" "part2.html#index46" )
        ("second" "part12.html#index578" )
        ("seq" "part6.html#index322" )
        ("seqrep" "part6.html#index323" )
        ("sequences" "part2.html#index16" )
        ("sequential behavior" "part3.html#index71" )
        ("set" "part12.html#index549" )
        ("set-control-srate" "part3.html#index79"  "part6.html#index139" )
        ("set-logical-stop" "part6.html#index326" )
        ("set-pitch-names" "part6.html#index143" )
        ("set-sound-srate" "part3.html#index80"  "part6.html#index141" )
        ("setf" "part12.html#index552" )
        ("setq" "part12.html#index550" )
        ("setup-console" "part12.html#index815" )
        ("sf-info" "part6.html#index361" )
        ("shape" "part6.html#index245" )
        ("shift-time" "part6.html#index176" )
        ("signal composition" "part6.html#index398"  "part6.html#index437" )
        ("signal multiplication" "part6.html#index427" )
        ("signal-start" "part6.html#index97" )
        ("signal-stop" "part6.html#index98" )
        ("sim" "part2.html#index10"  "part6.html#index324" )
        ("simrep" "part6.html#index325" )
        ("simultaneous behavior" "part3.html#index72" )
        ("sin" "part12.html#index704" )
        ("sine" "part6.html#index185" )
        ("siosc" "part6.html#index201" )
        ("sixteenth note" "part2.html#index37" )
        ("slope" "part6.html#index180" )
        ("smooth" "part6.html#index179" )
        ("snd-abs" "part6.html#index383" )
        ("snd-add" "part6.html#index387" )
        ("snd-alpass" "part6.html#index443" )
        ("snd-alpasscv" "part6.html#index444" )
        ("snd-alpassvv" "part6.html#index445" )
        ("snd-amosc" "part6.html#index465" )
        ("snd-areson" "part6.html#index446" )
        ("snd-aresoncv" "part6.html#index447" )
        ("snd-aresonvc" "part6.html#index448" )
        ("snd-aresonvv" "part6.html#index449" )
        ("snd-atone" "part6.html#index450" )
        ("snd-atonev" "part6.html#index451" )
        ("snd-avg" "part6.html#index391" )
        ("snd-biquad" "part6.html#index452" )
        ("snd-buzz" "part6.html#index467" )
        ("snd-chase" "part6.html#index453" )
        ("snd-clip" "part6.html#index396" )
        ("snd-compose" "part6.html#index399" )
        ("snd-congen" "part6.html#index454" )
        ("snd-const" "part6.html#index375" )
        ("snd-convolve" "part6.html#index455" )
        ("snd-copy" "part6.html#index405" )
        ("snd-coterm" "part6.html#index379" )
        ("snd-delay" "part6.html#index456"  "part6.html#index457" )
        ("snd-down" "part6.html#index407" )
        ("snd-exp" "part6.html#index408" )
        ("snd-extent" "part6.html#index109" )
        ("snd-fetch" "part6.html#index112" )
        ("snd-fetch-array" "part6.html#index114" )
        ("snd-fft" "part8.html#index476" )
        ("snd-flatten" "part6.html#index115" )
        ("snd-fmosc" "part6.html#index466" )
        ("snd-follow" "part6.html#index409" )
        ("snd-from-array" "part6.html#index105" )
        ("snd-fromarraystream" "part6.html#index106" )
        ("snd-fromobject" "part6.html#index107" )
        ("snd-gate" "part6.html#index414" )
        ("snd-ifft" "part8.html#index478" )
        ("snd-inverse" "part6.html#index418" )
        ("snd-length" "part6.html#index116" )
        ("snd-log" "part6.html#index419" )
        ("snd-max" "part6.html#index421" )
        ("snd-maxsamp" "part6.html#index117" )
        ("snd-maxv" "part6.html#index423" )
        ("snd-multiseq" "part6.html#index474" )
        ("snd-normalize" "part6.html#index425" )
        ("snd-offset" "part6.html#index388" )
        ("snd-osc" "part6.html#index469" )
        ("snd-overwrite" "part6.html#index378" )
        ("snd-partial" "part6.html#index470" )
        ("snd-play" "part6.html#index118" )
        ("snd-pluck" "part6.html#index468" )
        ("snd-print" "part6.html#index127" )
        ("snd-print-tree" "part6.html#index119"  "part6.html#index367" )
        ("snd-prod" "part6.html#index426" )
        ("snd-pwl" "part6.html#index429" )
        ("snd-quantize" "part6.html#index431" )
        ("snd-read" "part6.html#index376" )
        ("snd-recip" "part6.html#index432" )
        ("snd-resample" "part6.html#index433" )
        ("snd-resamplev" "part6.html#index435" )
        ("snd-reson" "part6.html#index458" )
        ("snd-resoncv" "part6.html#index459" )
        ("snd-resonvc" "part6.html#index460" )
        ("snd-resonvv" "part6.html#index461" )
        ("snd-samples" "part6.html#index121" )
        ("snd-save" "part6.html#index377" )
        ("snd-scale" "part6.html#index438" )
        ("snd-seq" "part6.html#index473" )
        ("snd-set-logical-stop" "part6.html#index129" )
        ("snd-shape" "part6.html#index439" )
        ("snd-sine" "part6.html#index471" )
        ("snd-siosc" "part6.html#index472" )
        ("snd-sqrt" "part6.html#index385"  "part6.html#index440" )
        ("snd-srate" "part6.html#index124" )
        ("snd-sref" "part6.html#index130" )
        ("snd-t0" "part6.html#index126" )
        ("snd-tapv" "part6.html#index400" )
        ("snd-time" "part6.html#index125" )
        ("snd-tone" "part6.html#index462" )
        ("snd-tonev" "part6.html#index464" )
        ("snd-xform" "part6.html#index442" )
        ("snd-zero" "part6.html#index382" )
        ("sort" "part12.html#index608" )
        ("sound" "part6.html#index151" )
        ("sound file directory default" "part6.html#index336" )
        ("sound file i/o" "part6.html#index334" )
        ("sound file info" "part6.html#index362" )
        ("sound from lisp data" "part6.html#index108" )
        ("sound, accessing point" "part6.html#index102" )
        ("sound, creating from array" "part6.html#index104" )
        ("sound-off" "part6.html#index342"  "part6.html#index347" )
        ("sound-on" "part6.html#index343"  "part6.html#index346" )
        ("sound-srate-abs" "part6.html#index307" )
        ("sound-warp" "part6.html#index177" )
        ("soundfilename" "part6.html#index363" )
        ("soundp" "part6.html#index131" )
        ("sounds" "part6.html#index94" )
        ("sounds vs. behaviors" "part3.html#index73" )
        ("spectral interpolation" "part6.html#index202" )
        ("splines" "part6.html#index206" )
        ("sqrt" "part12.html#index709" )
        ("square root" "part6.html#index273"  "part6.html#index386"  "part6.html#index441" )
        ("srate" "part6.html#index95" )
        ("sref" "part6.html#index101" )
        ("sref-inverse" "part6.html#index103" )
        ("st" "part2.html#index52" )
        ("stacatto" "part6.html#index314" )
        ("stack trace" "part12.html#index682" )
        ("stats" "part6.html#index132" )
        ("step-to-hz" "part6.html#index147" )
        ("stereo panning" "part6.html#index170" )
        ("strcat" "part12.html#index731" )
        ("streamp" "part12.html#index623" )
        ("stretch" "part2.html#index23"  "part6.html#index309"  "part6.html#index310" )
        ("stretching sampled sounds" "part5.html#index81" )
        ("string" "part12.html#index722" )
        ("string functions" "part12.html#index721" )
        ("string stream functions" "part12.html#index796" )
        ("string synthesis" "part6.html#index199" )
        ("string-downcase" "part12.html#index728" )
        ("string-equalp" "part12.html#index742" )
        ("string-left-trim" "part12.html#index725" )
        ("string-lessp" "part12.html#index740" )
        ("string-not-equalp" "part12.html#index743" )
        ("string-not-greaterp" "part12.html#index741" )
        ("string-not-lessp" "part12.html#index744" )
        ("string-right-trim" "part12.html#index726" )
        ("string-search" "part12.html#index723" )
        ("string-trim" "part12.html#index724" )
        ("string-upcase" "part12.html#index727" )
        ("string/=" "part12.html#index737" )
        ("string<" "part12.html#index734" )
        ("string<=" "part12.html#index735" )
        ("string=" "part12.html#index736" )
        ("string>" "part12.html#index739" )
        ("string>=" "part12.html#index738" )
        ("stringp" "part12.html#index620" )
        ("sublis" "part12.html#index600" )
        ("subseq" "part12.html#index733" )
        ("subst" "part12.html#index599" )
        ("suggestions" "part1.html#index4" )
        ("sum" "part6.html#index327" )
        ("sustain" "part6.html#index311" )
        ("sustain-abs" "part6.html#index315" )
        ("symbol functions" "part12.html#index548" )
        ("symbol-function" "part12.html#index560" )
        ("symbol-name" "part12.html#index558" )
        ("symbol-plist" "part12.html#index561" )
        ("symbol-value" "part12.html#index559" )
        ("symbolp" "part12.html#index611" )
        ("symbols" "part12.html#index517" )
        ("system functions" "part12.html#index801" )
        ("table" "part6.html#index247" )
        ("table memory" "part6.html#index134" )
        ("tagbody" "part12.html#index663" )
        ("tan" "part12.html#index706" )
        ("tap" "part6.html#index401" )
        ("terpri" "part12.html#index776" )
        ("the format function" "part12.html#index779" )
        ("the program feature" "part12.html#index657" )
        ("third" "part12.html#index579" )
        ("throw" "part12.html#index649" )
        ("time structure" "part6.html#index321" )
        ("timed-seq" "part6.html#index331" )
        ("tone" "part6.html#index237" )
        ("top-level" "part12.html#index677" )
        ("trace" "part12.html#index671" )
        ("transformation environment" "part3.html#index61" )
        ("transformations" "part3.html#index60"  "part6.html#index293" )
        ("transpose" "part6.html#index316" )
        ("transpose-abs" "part6.html#index317" )
        ("triangle oscillator" "part6.html#index190" )
        ("triangle wave" "part2.html#index14" )
        ("triplet durations" "part2.html#index57" )
        ("truncate" "part12.html#index686" )
        ("tuning" "part6.html#index144" )
        ("type-of" "part12.html#index810" )
        ("unless" "part12.html#index641" )
        ("untrace" "part12.html#index672" )
        ("unwind-protect" "part12.html#index650" )
        ("upper-case-p" "part12.html#index747" )
        ("variable delay" "part6.html#index402" )
        ("vector" "part12.html#index570" )
        ("w" "part2.html#index44" )
        ("warp" "part6.html#index318" )
        ("warp-abs" "part6.html#index319" )
        ("waveforms" "part2.html#index13" )
        ("waveshaping" "part6.html#index246" )
        ("wavetables" "part2.html#index12" )
        ("wd" "part2.html#index50" )
        ("when" "part12.html#index640" )
        ("whole note" "part2.html#index45" )
        ("window initialization" "part12.html#index816" )
        ("write samples to file" "part6.html#index350" )
        ("write-byte" "part12.html#index795" )
        ("write-char" "part12.html#index788" )
        ("write-float" "part12.html#index792" )
        ("write-int" "part12.html#index790" )
        ("wt" "part2.html#index56" )
        ("xlisp command loop" "part12.html#index488" )
        ("xlisp data types" "part12.html#index495" )
        ("xlisp evaluator" "part12.html#index498" )
        ("xlisp lexical conventions" "part12.html#index500" )
        ("zerop" "part12.html#index628")))

(defun ny-eval-string (string)
  "Send STRING to the inferior Lisp process."
  (comint-send-string (inferior-lisp-proc) (concat string "\n")))

(defun ny-play-region (beg end &optional and-go)
  "Embed region in a (play ...) FORM and eval it."
  (interactive "r\nP")
  (ny-eval-string
   (format "(play %s)" (buffer-substring-no-properties beg end)))
  (and and-go (switch-to-lisp t)))

(defun ny-clean-up ()
  (interactive)
  (ny-eval-string "(clean-up)"))

(defun ny-top-level ()
  (interactive)
  (ny-eval-string "(top-level)"))

(defun ny-continue ()
  (interactive)
  (ny-eval-string "(continue)"))

(defun ny ()
  "Run nyquist in an inferior lisp shell."
  (interactive)
  (run-lisp (or ny-startup-string (expand-file-name (shell-command-to-string "which ny")))))

(defun ny-enclose-in-play ()
  (interactive)
  (condition-case nil
      (up-list))
  (insert-parentheses -1)
  (insert "play "))

(defun ny-info ()
  (interactive)
  (browse-url 
   (format "%s%s" ny-doc-root "home.html")))

(defun ny-lookup ()
  (interactive)
  (let ((request
         (cdr (assoc (completing-read "Lookup documentation: " ny-doc-list nil t 
                                      (or (and (symbol-at-point) 
                                               (member 
                                                (symbol-name (symbol-at-point))
                                                (mapcar 'car ny-doc-list))
                                               (symbol-name (symbol-at-point))) "")) ny-doc-list))))
    (let ((url
           (format "%s%s" ny-doc-root
                   (cond ((null (cdr request)) (car request))
                         (t 
                          (nth (1- (read-number 
                                    (format "Multiple references, choose one from 1 to %d: " (length request)) 1))
                               request))))))
      (browse-url url))))

(provide 'nyquist)
;;; nyquist.el ends here

