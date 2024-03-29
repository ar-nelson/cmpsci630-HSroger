/**************************************************************************/
/* File:        modes.h                                                   */
/* Description: everything for input and control modes of the simulator   */
/* Author:      Rod Grupen                                                */
/* Date:        11-1-2009                                                 */
/**************************************************************************/
#ifndef MODES_H
#define MODES_H

//Mouse buttons
#define LEFT_BUTTON Button1
#define MIDDLE_BUTTON Button2
#define RIGHT_BUTTON Button3

/**************************************************************************/
// Modes
enum input_modes {
	BASE_GOAL_INPUT = 0,
	ARM_GOAL_INPUT,
	TOY_INPUT,
	MAP_INPUT,
	N_INPUT_MODES  //number of modes
};

enum control_modes {
  PROJECT1 = 0,
  PROJECT2,
  PROJECT3,
  PROJECT4,
  PROJECT5,
  PROJECT6,
  PROJECT7,
  PROJECT8,
  PROJECT9,
  N_CONTROL_MODES //number of modes
};

enum room_num {
  R0 = 0,
  R1,
  R2,
  N_ROOMS // number of rooms
};

#endif
