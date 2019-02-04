
(import scheme (chicken base) random-mtzig)

(define st (init))

(define v (randn/f64! 100 st))

(print v)

