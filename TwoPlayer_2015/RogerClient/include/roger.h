/**************************************************************************/
/* File:        Roger.h                                                   */
/* Description: all the compile time constants that define Roger          */
/*              IMPORTANT --- READ ONLY --- DO NOT EDIT THIS FILE         */
/* Author:      Rod Grupen                                                */
/* Date:        11-1-2009                                                 */
/**************************************************************************/

/**************************************************************************/
// environmental constants
/**************************************************************************/
#define GRAVITY        0.0   /* [m/sec^2] - gravitational constant -y dir */
                             /* mm sim does not yet accomodate gravity    */

/**************************************************************************/
// morphological constants
/**************************************************************************/
#define NWHEELS        2
#define NARMS          2
#define NARM_LINKS     2
#define NARM_JOINTS    2
#define NARM_FRAMES    4
#define NEYES          2
#define NPIXELS      128     /* array size of 1D image structure */

/**************************************************************************/
// geometrical constants
/**************************************************************************/
#define R_BASE         0.16  /* [m] - the radius of Roger's body */
#define R_WHEEL        0.04  /* [m] - the thickness of a wheel */
#define R_AXLE         0.20  /* [m] - the radius to wheel contact w/ground */
#define WHEEL_RADIUS   0.1   /* [m] - the radius of the wheel */

#define ARM_OFFSET     0.18  /* [m] - 1/2 distance between arms */
#define LARM_1         0.5   /* [m] - the length of link 1 */
#define LARM_2         0.5   /* [m] - the length of link 2 */

#define MARM_1         0.2   /* [kg] - mass of arm link 1 (upper arm) */
#define MARM_2         0.2   /* [kg] - mass of arm link 2 (forearm)   */
#define IARM_1 (MARM_1*LARM_1*LARM_1) /* [kg m^2] - link 1 moment of inertia */
#define IARM_2 (MARM_2*LARM_2*LARM_2) /* [kg m^2] - link 2 moment of inertia */

#define L_EYE          0.04  /* [m] - the length of an eye link*/
#define M_EYE          0.05  /* [kg] - mass of the eye */
#define I_EYE  (M_EYE*L_EYE*L_EYE) /* [kg m^2] - eye moment of inertia */

#define BASELINE       0.08  /* [m] - 1/2 distance between eyes */
#define FOCAL_LENGTH  64.0   /* [pixels] - focal length */

/**************************************************************************/
// graphical constants - just for rendering
/**************************************************************************/
#define R_JOINT        0.02  /* [m] - the radius of an arm joint */
#define R_TACTILE      0.08  /* [m] - radius of tactile cell */

#define R_EYE          0.07  /* [m] - the radius of an eye */
#define R_PUPIL        0.04  /* [m] - the radius of a pupil */

#define IMAGE_WIDTH  256
#define FOV (atan2((double)(NPIXELS/2.0), (double)FOCAL_LENGTH))
                             /* [rad] - half angle of FOV  */

#define R_OBJ          0.20  /* [m] - the radius of the red ball */

#define M_BALL       0.5   /* [kg] */
#define I_BALL       0.02  /* [kg m^2] */
#define R_BALL       0.20  /* [m] - the radius of the red ball */

// parameters used to compute collision forces between the arm and the ball
#define K_COLLIDE    4500.0 //500.0
#define B_COLLIDE      5.5 //2.5
#define OBJ_GRAVITY    0.0  /* neutrally buoyant */

// probably should go in control.h
#define VISCOSITY      0.05
#define STATIC_FORCE_THRESHOLD 10.0

// for visual appearance of ball - probably should go in control.h
#define NFEATURES      3
#define CENTROID       0
#define LEFT_EDGE      1
#define RIGHT_EDGE     2

/**************************************************************************/
// motor constants
/**************************************************************************/
// stall-torques
#define WHEEL_TS		475.00
#define EYE_TS 			2.71
#define ELBOW_TS		120.72
#define SHOULDER_TS     205.30

// motor no-load speed
#define WHEEL_WS		175.0
#define EYE_WS 			122.21
#define ELBOW_WS		50.30
#define SHOULDER_WS     30.01
