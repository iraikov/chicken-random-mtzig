;;
;; Chicken bindings for an implementation of the MT19937 random number
;; generator with Marsaglia and Tang's Ziggurat algorithm to generate
;; random numbers from a non-uniform distribution.
;;
;; Chicken library created by Ivan Raikov
;;
;; randmtzig.c Coded by Takuji Nishimura and Makoto Matsumoto.
;; This is a faster version by taking Shawn Cokus's optimization,
;; Matthe Bellew's simplification, Isaku Wada's real version.
;; David Bateman added normal and exponential distributions following
;; Marsaglia and Tang's Ziggurat algorithm.
;;
;;   Copyright (C) 1997 - 2002, Makoto Matsumoto and Takuji Nishimura,
;;   Copyright (C) 2004, David Bateman
;;
;;   Redistribution and use in source and binary forms, with or without
;;   modification, are permitted provided that the following conditions
;;   are met:
;;   
;;     1. Redistributions of source code must retain the above copyright
;;        notice, this list of conditions and the following disclaimer;.
;;
;;     2. Redistributions in binary form must reproduce the above copyright
;;        notice, this list of conditions and the following disclaimer in the
;;        documentation and/or other materials provided with the distribution.
;;
;;     3. The names of its contributors may not be used to endorse or promote 
;;        products derived from this software without specific prior written 
;;        permission.
;;
;;

(module random-mtzig
 
  (random-mtzig:init
   random-mtzig:random!

   random-mtzig:randu! 
   random-mtzig:randn! 
   random-mtzig:rande!
   random-mtzig:randb!
   random-mtzig:randp!

   random-mtzig:f64vector-randu!
   random-mtzig:f64vector-randn! 
   random-mtzig:f64vector-rande!
   random-mtzig:f64vector-randb!
   random-mtzig:f64vector-randp!

   random-mtzig:f32vector-randu!
   random-mtzig:f32vector-randn!
   random-mtzig:f32vector-rande!
   random-mtzig:f32vector-randb! 
   random-mtzig:f32vector-randp!
   )

  (import scheme chicken foreign )

  (require-extension srfi-4 bind)


(bind* #<<EOF

typedef int randmtzig_idx_type;

typedef signed char randmtzig_int8_t;
typedef unsigned char randmtzig_uint8_t;

typedef short randmtzig_int16_t;
typedef unsigned short randmtzig_uint16_t;

typedef int randmtzig_int32_t;
typedef unsigned int randmtzig_uint32_t;

typedef unsigned int randmtzig_uint64_t;

#define MT_N 624
#define ZT_SIZE 256

/* === Mersenne Twister === */
void randmtzig_init_by_int (randmtzig_uint32_t s, randmtzig_uint32_t *state);
void randmtzig_init_by_array (randmtzig_uint32_t *init_key, ___length(init_key) int key_length, 
			      randmtzig_uint32_t *state);
void randmtzig_init_by_entropy (randmtzig_uint32_t *state);

/* === Uniform and non-uniform distribution generators === */
randmtzig_uint32_t randmtzig_randi32 (randmtzig_uint32_t *state);
double randmtzig_randu (randmtzig_uint32_t *state);
double randmtzig_randn (randmtzig_uint32_t *state, randmtzig_uint64_t *ki, randmtzig_uint64_t *ke, double *wi, double *fi,
		        double *we, double *fe);
double randmtzig_rande (randmtzig_uint32_t *state, randmtzig_uint64_t *ki, randmtzig_uint64_t *ke, double *wi, double *fi,
		        double *we, double *fe);
double randmtzig_randb(int nnr, double ppr, randmtzig_uint32_t *state);
double randmtzig_randp (double L, randmtzig_uint32_t *state, randmtzig_uint64_t *ki, randmtzig_uint64_t *ke, double *wi, double *fi, 
                        double *we, double *fe);

/* === Array generators === */
void randmtzig_fill_drandu (randmtzig_idx_type n, double *p, randmtzig_uint32_t *state);

void randmtzig_fill_drandn (randmtzig_idx_type n, double *p, randmtzig_uint32_t *state,
		       randmtzig_uint64_t *ki, randmtzig_uint64_t *ke, double *wi, double *fi,
		       double *we, double *fe);

void randmtzig_fill_drande (randmtzig_idx_type n, double *p, randmtzig_uint32_t *state,
		       randmtzig_uint64_t *ki, randmtzig_uint64_t *ke, double *wi, double *fi,
		       double *we, double *fe);

void randmtzig_fill_drandb (int nnr, double ppr,
			    randmtzig_idx_type n, double *p, randmtzig_uint32_t *state);

void randmtzig_fill_drandp (double L, randmtzig_idx_type n, double *p, randmtzig_uint32_t *state,
			    randmtzig_uint64_t *ki, randmtzig_uint64_t *ke, double *wi, double *fi,
			    double *we, double *fe);

void randmtzig_fill_srandu (randmtzig_idx_type n, float *p, randmtzig_uint32_t *state);

void randmtzig_fill_srandn (randmtzig_idx_type n, float *p, randmtzig_uint32_t *state,
		       randmtzig_uint64_t *ki, randmtzig_uint64_t *ke, double *wi, double *fi,
		       double *we, double *fe);

void randmtzig_fill_srande (randmtzig_idx_type n, float *p, randmtzig_uint32_t *state,
		       randmtzig_uint64_t *ki, randmtzig_uint64_t *ke, double *wi, double *fi,
		       double *we, double *fe);

void randmtzig_fill_srandb (int nnr, float ppr,
			    randmtzig_idx_type n, float *p, randmtzig_uint32_t *state);

void randmtzig_fill_srandp (float L, randmtzig_idx_type n, float *p, randmtzig_uint32_t *state,
			    randmtzig_uint64_t *ki, randmtzig_uint64_t *ke, double *wi, double *fi,
		            double *we, double *fe);

EOF
)

(define (make-zt)
  (list (make-u32vector (* 2 ZT_SIZE))
	(make-u32vector (* 2 ZT_SIZE))
	(make-f64vector ZT_SIZE)
	(make-f64vector ZT_SIZE)
	(make-f64vector ZT_SIZE)
	(make-f64vector ZT_SIZE)))

(define (random-mtzig:init . rest)
  (let-optionals rest ((s #f))
    (let ((st  (make-u32vector (+ MT_N 4))))
      (cond ((integer? s)    (randmtzig_init_by_int s st))
	    ((u32vector? s)  (randmtzig_init_by_array s st))
	    (else            (randmtzig_init_by_entropy st)))
      (list st))))


(define (random-mtzig:random! st)
  (randmtzig_randi32 (car st)))


(define (random-mtzig:randu! st)
  (randmtzig_randu (car st)))


(define (random-mtzig:randn! st)
  (if (null? (cdr st))
      (set-cdr! st (make-zt)))
  (apply randmtzig_randn st))


(define (random-mtzig:rande! st)
  (if (null? (cdr st))
      (set-cdr! st (make-zt)))
  (apply randmtzig_rande st))


(define (random-mtzig:randb! n p st)
  (randmtzig_randb n p (car st)))

(define (random-mtzig:randp! L st)
  (if (null? (cdr st))
      (set-cdr! st (make-zt)))
  (apply randmtzig_randp (cons L st)))


(define (random-mtzig:f64vector-randu! n st)
  (let ((v (make-f64vector n 0.0)))
    (apply randmtzig_fill_drandu (list n v (car st)))
    v))


(define (random-mtzig:f64vector-randn! n st)
  (let ((v (make-f64vector n 0.0)))
    (if (null? (cdr st))
	(set-cdr! st (make-zt)))
    (apply randmtzig_fill_drandn (cons n (cons v st)))
    v))


(define (random-mtzig:f64vector-rande! n st)
  (let ((v (make-f64vector n 0.0)))
      (if (null? (cdr st))
	  (set-cdr! st (make-zt)))
      (apply randmtzig_fill_drande (cons n (cons v st)))
      v))


(define (random-mtzig:f64vector-randb! n p len st)
  (let ((v (make-f64vector len 0.0)))
    (apply randmtzig_fill_drandb (list n p len v (car st)))
    v))


(define (random-mtzig:f64vector-randp! L len st)
  (let ((v (make-f64vector len 0.0)))
    (if (null? (cdr st))
	(set-cdr! st (make-zt)))
    (apply randmtzig_fill_drandp (append (list L len v) st))
    v))


(define (random-mtzig:f32vector-randu! n st)
  (let ((v (make-f32vector n 0.0)))
    (apply randmtzig_fill_srandu (list n v (car st)))
    v))


(define (random-mtzig:f32vector-randn! n st)
  (let ((v (make-f32vector n 0.0)))
    (if (null? (cdr st))
	(set-cdr! st (make-zt)))
    (apply randmtzig_fill_srandn (cons n (cons v st)))
    v))


(define (random-mtzig:f32vector-rande! n st)
  (let ((v (make-f32vector n 0.0)))
    (if (null? (cdr st))
	(set-cdr! st (make-zt)))
    (apply randmtzig_fill_srande (cons n (cons v st)))
    v))


(define (random-mtzig:f32vector-randb! n p len st)
  (let ((v (make-f32vector len 0.0)))
    (apply randmtzig_fill_srandb (list n p len v (car st)))
    v))


(define (random-mtzig:f32vector-randp! L len st)
  (let ((v (make-f32vector len 0.0)))
    (if (null? (cdr st))
	(set-cdr! st (make-zt)))
    (apply randmtzig_fill_srandp (append (list L len v) st))
    v))

)
