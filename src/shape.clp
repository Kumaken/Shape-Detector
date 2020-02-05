(
    deftemplate shape
        (slot name)
        (slot edge-count)
        (slot angle-trait (default none))
        (slot length-trait (default none))
)
(
    deftemplate raw_input
        (slot nth)
        (slot length)
        (slot slope (default none))
)
(
    deffacts shapes
        (shape (name acute-triangle) (edge-count 3) (angle-trait acute) (length-trait none))
        (shape (name obtuse-triangle) (edge-count 3) (angle-trait obtuse) (length-trait none))
        (shape (name right-triangle) (edge-count 3) (angle-trait perpendicular) (length-trait none))
        (shape (name isosceles-right-triangle) (edge-count 3) (angle-trait perpendicular) (length-trait isosceles))
        (shape (name isosceles-obtuse-triangle) (edge-count 3) (angle-trait obtuse) (length-trait isosceles))
        (shape (name isosceles-acute-triangle) (edge-count 3) (angle-trait acute) (length-trait isosceles))

        (shape (name equilateral-triangle) (edge-count 3) (angle-trait none) (length-trait equilateral))
        (shape (name equilateral-triangle) (edge-count 3) (angle-trait acute) (length-trait equilateral))

        (shape (name square) (edge-count 4) (angle-trait none) (length-trait equilateral))
        (shape (name kite) (edge-count 4) (angle-trait none) (length-trait kite))
        (shape (name rectangle) (edge-count 4) (angle-trait none) (length-trait isosceles))
        (shape (name arbitrary-rectangle) (edge-count 4) (angle-trait none) (length-trait none))

        (shape (name regular-trapezium) (edge-count 4) (angle-trait trapezium) (length-trait none))
        (shape (name isosceles-trapezium) (edge-count 4) (angle-trait trapezium) (length-trait isosceles))
        (shape (name lefthand-trapezium) (edge-count 4) (angle-trait trapezium) (length-trait lefthand))
        (shape (name righthand-trapezium) (edge-count 4) (angle-trait trapezium) (length-trait righthand))

        (shape (name regular-pentagon) (edge-count 5) (angle-trait none) (length-trait none))
        (shape (name equilateral-pentagon) (edge-count 5) (angle-trait none) (length-trait equilateral))

        (shape (name regular-hexagon) (edge-count 6) (angle-trait none) (length-trait none))
        (shape (name equilateral-hexagon) (edge-count 6) (angle-trait none) (length-trait equilateral))
)
(
    defrule reset-outputfile
        (declare (salience 1000))
        =>
        (open "outputfile.txt" outputfile "w")
        (close)
)
(
    defrule find-edge-number
        (declare (salience 200))
        =>
        (open "outputfile.txt" outputfile "a")
        (printout outputfile "R_M_:find-edge-number" crlf)
        (assert ( edge-count (length$ (find-all-facts ((?f raw_input)) TRUE))))
        (printout outputfile "A_F_:(edge-count " (length$ (find-all-facts ((?f raw_input)) TRUE)) ")" crlf)
        (close)
)
(
    defrule find-longest-edge
        (not (exists (max ?max)))

        (raw_input (nth ?nth1) (length ?length1))
        (not (raw_input (length ?length2&:(> ?length2 ?length1))))
        =>
        (open "outputfile.txt" outputfile "a")
        (printout outputfile "R_M_:find-longest-edge" crlf)
        (assert(max ?nth1))
        (printout outputfile "A_F_:(longest-edge "?nth1")" crlf)
        (close)
)
(
    defrule find-shortest-edge
        (not (exists (min ?min)))

        (raw_input (nth ?nth1) (length ?length1))
        (not (raw_input (length ?length2&:(< ?length2 ?length1))))
        =>
        (open "outputfile.txt" outputfile "a")
        (printout outputfile "R_M_:find-shortest-edge" crlf)
        (assert(min ?nth1))
        (printout outputfile "A_F_:(shortest-edge "?nth1")" crlf)
        (close)
)
(
    defrule find-2middle-edge
        (not (exists (mid1 ?mid1)))
        (not (exists (mid2 ?mid2)))
        (edge-count ?edge-count)
        (test (= ?edge-count 4))

        (max ?max)
        (min ?min)
        (raw_input (nth ?nth1) (length ?length1))
        (test (!= ?nth1 ?max))
        (test (!= ?nth1 ?min))
        (raw_input (nth ?nth2) (length ?length2))
        (test (!= ?nth2 ?max))
        (test (!= ?nth2 ?min))
        (test (!= ?nth2 ?nth1))

        (test (>= ?length2 ?length1))
        =>
        (open "outputfile.txt" outputfile "a")
        (printout outputfile "R_M_:find-2middle-edge" crlf)
        (assert(mid1 ?nth1))
        (printout outputfile "A_F_:(middle-edge-1 "?nth1")" crlf)
        (assert(mid2 ?nth2))
        (printout outputfile "A_F_:(middle-edge-2 "?nth2")" crlf)
        (close)
)
(
    defrule find-parallel-edges
        (edge-count ?edge-count)
        (test (= ?edge-count 4))
        (not (exists (parallel1 ?parallel1)))
        (not (exists (parallel2 ?parallel2)))
        (raw_input (nth ?nth1) (slope ?slope1))
        (raw_input (nth ?nth2) (slope ?slope2&: (<= (abs (- ?slope1 ?slope2)) 10)))
        (test (!= ?nth1 ?nth2))
        =>
        (open "outputfile.txt" outputfile "a")
        (printout outputfile "R_M_:find-parallel-edges" crlf)
        (assert(parallel1 ?nth1))
        (printout outputfile "A_F_:(parallel-edge-1 "?nth1")" crlf)
        (assert(parallel2 ?nth2))
        (printout outputfile "A_F_:(parallel-edge-2 "?nth2")" crlf)
        (close)
)
(
    defrule find-ndparallel-edges
        (edge-count ?edge-count)
        (test (= ?edge-count 4))
        (not (exists (ndparallel1 ?ndparallel1)))
        (not (exists (ndparallel2 ?ndparallel2)))
        (raw_input (nth ?nth1) (slope ?slope1))

        (raw_input (nth ?nth2) (slope ?slope2&: (<= (abs (- ?slope1 ?slope2)) 10)) )
        (test (!= ?nth1 ?nth2))

        (parallel1 ?parallel1)
        (parallel2 ?parallel2)
        (test (!= ?nth1 ?parallel1))
        (test (!= ?nth1 ?parallel2))
        (test (!= ?nth2 ?parallel1))
        (test (!= ?nth2 ?parallel2))
        =>
        (open "outputfile.txt" outputfile "a")
        (printout outputfile "R_M_:find-ndparallel-edges" crlf)
        (assert(ndparallel1 ?nth1))
        (printout outputfile "A_F_:(ndparallel-edge-1 "?nth1")" crlf)
        (assert(ndparallel2 ?nth2))
        (printout outputfile "A_F_:(ndparallel-edge-2 "?nth2")" crlf)
        (close)
)
(
    defrule find-middle-edge
        (not (exists (mid ?mid)))
        (edge-count ?edge-count)
        (test (= ?edge-count 3))

        (max ?max)
        (min ?min)
        (raw_input (nth ?nth1) (length ?length1))
        (test (!= ?nth1 ?max))
        (test (!= ?nth1 ?min))
        =>
        (open "outputfile.txt" outputfile "a")
        (printout outputfile "R_M_:find-middle-edge" crlf)
        (assert(mid ?nth1))
        (printout outputfile "A_F_:(middle-edge "?nth1")" crlf)
        (close)
)
(
    defrule find-phytagoras-diff
        (not (exists (pdiff ?pdiff)))
        (edge-count ?edge-count)
        (test (= ?edge-count 3))

        (max ?max)
        ?maxid <- (raw_input (nth ?max))
        (min ?min)
        ?minid <- (raw_input (nth ?min))
        (mid ?mid)
        ?midid <- (raw_input (nth ?mid))
        =>
        (open "outputfile.txt" outputfile "a")
        (bind ?maxval (fact-slot-value ?maxid length))
        (bind ?minval (fact-slot-value ?minid length))
        (bind ?midval (fact-slot-value ?midid length))
        (printout outputfile "R_M_:find-phytagoras-diff" crlf)
        (assert(pdiff (- (* ?maxval ?maxval) (+  (* ?minval ?minval) (* ?midval ?midval)) )))
        (printout outputfile "A_F_:(phytagoras_diff " (- (* ?maxval ?maxval) (+  (* ?minval ?minval) (* ?midval ?midval)) ) ")" crlf)
        (close)
)
(
    defrule deduce-equilaterality
        (declare (salience 200))
        (not (exists (length-trait ?length-trait)))

        (max ?max)
        ?maxid <- (raw_input (nth ?max))
        (min ?min)
        ?minid <- (raw_input (nth ?min))

        =>
        (open "outputfile.txt" outputfile "a")
        (bind ?maxval (fact-slot-value ?maxid length))
        (bind ?minval (fact-slot-value ?minid length))
        (printout t "checkEqui " (abs (- (/ ?maxval ?minval) 1)) crlf)
        (if (<= (abs (- (/ ?maxval ?minval) 1)) 0.2)
            then
            (printout outputfile "R_M_:deduce-equilaterality" crlf)
            (assert(length-trait equilateral)) )
            (printout outputfile "A_F_:(length-trait equilateral)" crlf)
        (close)
)
(
    defrule deduce-isosceles-triangle
        (not (exists (length-trait ?length-trait)))
        (edge-count ?edge-count)
        (test (= ?edge-count 3))

        (max ?max)
        ?maxid <- (raw_input (nth ?max))
        (min ?min)
        ?minid <- (raw_input (nth ?min))
        (mid ?mid)
        ?midid <- (raw_input (nth ?mid))


        =>
        (open "outputfile.txt" outputfile "a")
        (printout outputfile "TRY:deduce-isosceles-triangle" crlf)
        (bind ?maxval (fact-slot-value ?maxid length))
        (bind ?minval (fact-slot-value ?minid length))
        (bind ?midval (fact-slot-value ?midid length))
        (if (<= (abs (- (/ ?maxval ?minval) 1)) 0.2)
            then
            (printout outputfile "R_M_:deduce-isosceles-triangle" crlf)
            (assert(length-trait isosceles))
            (printout outputfile "A_F_:(length-trait isosceles)" crlf)
            else
            (if (<= (abs (- (/ ?midval ?minval) 1)) 0.2)
                then
                (printout outputfile "R_M_:deduce-isosceles-triangle" crlf)
                (assert(length-trait isosceles))
                (printout outputfile "A_F_:(length-trait isosceles)" crlf)
            )

        )
        (close)
)
(
    defrule deduce-kite
        (not (exists (length-trait ?length-trait)))
        (edge-count ?edge-count)
        (test (= ?edge-count 4))
        (max ?max)
        ?maxid <- (raw_input (nth ?max))
        (min ?min)
        ?minid <- (raw_input (nth ?min))
        (mid1 ?mid1)
        ?mid1id <- (raw_input (nth ?mid1))
        (mid2 ?mid2)
        ?mid2id <- (raw_input (nth ?mid2))

        (or (test(= (abs(- ?max  ?mid2)) 1)) (test(= (abs(- ?max  ?mid2)) 3)))
        (or (test(= (abs(- ?mid1  ?min)) 1)) (test(= (abs(- ?mid1  ?min)) 3)))
        =>
        (open "outputfile.txt" outputfile "a")

        (bind ?maxval (fact-slot-value ?maxid length))
        (bind ?minval (fact-slot-value ?minid length))
        (bind ?mid1val (fact-slot-value ?mid1id length))
        (bind ?mid2val (fact-slot-value ?mid2id length))

        (printout t "kitecheck" (abs (- (/ ?mid2val ?maxval) 1)) crlf)
        (if (<= (abs (- (/ ?mid2val ?maxval) 1)) 0.2)
            then
                (if  (<= (abs (- (/ ?mid1val ?minval) 1)) 0.2)
                    then
                        (printout outputfile "R_M_:deduce-kite" crlf)
                        (assert(length-trait kite))
                        (printout outputfile "A_F_:(length-trait kite)" crlf)
                )
        )
        (close)
)
(
    defrule deduce-isosceles-trapezium
        (not (exists (length-trait ?length-trait)))
        (edge-count ?edge-count)
        (test (= ?edge-count 4))

        (nth ?nth1)
        (nth ?nth2)
        (parallel1 ?parallel1)
        (parallel2 ?parallel2)
        (test(!= ?nth1 ?parallel1))
        (test(!= ?nth1 ?parallel2))
        (test(!= ?nth2 ?parallel1))
        (test(!= ?nth2 ?parallel2))
        ?id1 <- (raw_input (nth ?nth1))
        ?id2 <- (raw_input (nth ?nth2))
        =>
        (open "outputfile.txt" outputfile "a")
        (printout outputfile "TRY:deduce-isosceles-triangle" crlf)
        (bind ?val1 (fact-slot-value ?id1 length))
        (bind ?val2 (fact-slot-value ?id2 length))
        (printout outputfile "val1: " ?val1 "val2: " ?val2 crlf)
        (if (<= (abs (- (/ ?val1 ?val2) 1)) 0.2)
            then
            (printout outputfile "R_M_:deduce-isosceles-trapezium" crlf)
            (assert(length-trait isosceles))
            (printout outputfile "A_F_:(length-trait isosceles)" crlf)
        )
        (close)
)
(
    defrule deduce-lefthand
        (not (exists (ndparallel1 ?ndparallel1)))
        (not (exists (ndparallel2 ?ndparallel2)))
        (not (exists (length-trait ?length-trait)))
        (edge-count ?edge-count)
        (test (= ?edge-count 4))
        (parallel1 ?parallel1)
        (parallel2 ?parallel2)
        (raw_input (nth ?nth1) (length ?length1))
        (test (!= ?nth1 ?parallel1))
        (test (!= ?nth1 ?parallel2))
        (raw_input (nth ?nth2) (length ?length2))
        (test (!= ?nth2 ?parallel1))
        (test (!= ?nth2 ?parallel2))
        (test (!= ?nth2 ?nth1))
        (test (< ?nth1 ?nth2))
        (test (< ?length1 ?length2))
        =>
        (open "outputfile.txt" outputfile "a")
        (printout outputfile "R_M_:deduce-lefthand" crlf)
        (assert (length-trait lefthand))
        (printout outputfile "A_F_:(length-trait lefthand)" crlf)
        (close)
)
(
    defrule deduce-righthand
        (not (exists (ndparallel1 ?ndparallel1)))
        (not (exists (ndparallel2 ?ndparallel2)))
        (not (exists (length-trait ?length-trait)))
        (edge-count ?edge-count)
        (test (= ?edge-count 4))
        (parallel1 ?parallel1)
        (parallel2 ?parallel2)
        (raw_input (nth ?nth1) (length ?length1))
        (test (!= ?nth1 ?parallel1))
        (test (!= ?nth1 ?parallel2))
        (raw_input (nth ?nth2) (length ?length2))
        (test (!= ?nth2 ?parallel1))
        (test (!= ?nth2 ?parallel2))
        (test (< ?nth1 ?nth2))
        (test (> ?length1 ?length2))
        =>
        (open "outputfile.txt" outputfile "a")
        (printout outputfile "R_M_:deduce-righthand" crlf)
        (assert (length-trait righthand))
        (printout outputfile "A_F_:(length-trait righthand)" crlf)
        (close)
)
(
    defrule deduce-acute-triangle
        (not (exists (angle-trait ?angle-trait)))
        (edge-count ?edge-count)
        (test (= ?edge-count 3))

        (pdiff ?pdiff)
        (test (< ?pdiff 0))
        =>
        (open "outputfile.txt" outputfile "a")
        (printout outputfile "R_M_:deduce-acute-triangle" crlf)
        (assert(angle-trait acute))
        (printout outputfile "A_F_:(angle-trait acute)" crlf)
        (close)
)
(
    defrule deduce-obtuse-triangle
        (not (exists (angle-trait ?angle-trait)))
        (edge-count ?edge-count)
        (test (= ?edge-count 3))

        (pdiff ?pdiff)
        (test (> ?pdiff 0))
        =>
        (open "outputfile.txt" outputfile "a")
        (printout outputfile "R_M_:deduce-obtuse-triangle" crlf)
        (assert(angle-trait obtuse))
        (printout outputfile "A_F_:(angle-trait obtuse)" crlf)
        (close)
)
(
    defrule deduce-right-triangle
        (not (exists (angle-trait ?angle-trait)))
        (edge-count ?edge-count)
        (test (= ?edge-count 3))

        (pdiff ?pdiff)
        (test (< ?pdiff 0.01))
        =>
        (open "outputfile.txt" outputfile "a")
        (printout outputfile "R_M_:deduce-right-triangle" crlf)
        (assert(angle-trait right))
        (printout outputfile "A_F_:(angle-trait right)" crlf)
        (close)
)



(
    defrule deduce-trapezium
        (not (exists (angle-trait ?angle-trait)))
        (edge-count ?edge-count)
        (test (= ?edge-count 4))
        (parallel1 ?parallel1)
        (parallel2 ?parallel2)
        =>
        (open "outputfile.txt" outputfile "a")
        (printout outputfile "R_M_:deduce-trapezium" crlf)
        (assert(angle-trait trapezium))
        (printout outputfile "A_F_:(angle-trait trapezium)" crlf)
		(close)
)

(
    defrule fill-none-length
    (not (exists (length-trait ?length-trait)))
    =>
    (open "outputfile.txt" outputfile "a")
    (printout outputfile "R_M_:fill-none-length" crlf)
    (assert(length-trait none))
    (printout outputfile "A_F_:(length-trait none)" crlf)
    (close)
)
(
    defrule fill-none-angle
    (not (exists (angle-trait ?angle-trait)))
    =>
    (open "outputfile.txt" outputfile "a")
    (printout outputfile "R_M_:fill-none-angle" crlf)
    (assert(angle-trait none))
    (printout outputfile "A_F_:(angle-trait none)" crlf)
    (close)
)
(
    defrule checking-input
        (declare (salience -200))
        (edge-count ?edge-count)
        (angle-trait ?angle-trait)
        (length-trait ?length-trait)
        (shape (name ?name1) (edge-count ?edge-count1) (angle-trait ?angle-trait1) (length-trait ?length-trait1))
        (test (eq ?edge-count ?edge-count1))
        (test (eq ?angle-trait ?angle-trait1))
        (test (eq ?length-trait ?length-trait1))
        =>
        (open "outputfile.txt" outputfile "a")
        (printout outputfile "F_R_:" ?name1 crlf)
        (close)
)