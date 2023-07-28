/* Copyright 2020 pondersson
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
#include QMK_KEYBOARD_H

// Defines names for use in layer keycodes and the keymap
#define _MODMH 0
#define _SWEMH 1
#define _QWERTY 2
#define _MELEE 3
#define _NAVIGATION 4
#define _SYMBOL 5
#define _LOWER 6
#define _RAISE 7
#define _ADJUST 8

// Defines the keycodes used by our macros in process_record_user
enum custom_keycodes {
  MODMH = SAFE_RANGE,
  SWEMH,
  QWERTY,
  COLEMAK,
  NAVIGATION,
  SYMBOL,
  LOWER,
  RAISE,
};

enum unicode_names {
  SMIL,
  SMRK,
  JOY,
  THNK,
  THUM,
  OK,
  WAVE,
  EYES,
};

const uint32_t PROGMEM unicode_map[] = {
  [SMIL] = 0x1F642,
  [SMRK] = 0x1F60F,
  [JOY] = 0x1F602,
  [THNK] = 0x1F914,
  [THUM] = 0x1F44D,
  [OK] = 0x1F44C,
  [WAVE] = 0x1F44B,
  [EYES] = 0x1F440,
};

// Tap dance
enum tap_dance_sequences {
  TD_ALT_GUI,
  TD_SFT_CAPS,
  TD_SYMB_RALT,
};

// Custom functions for momentary layers
void td_symb_ralt_finished(qk_tap_dance_state_t *state, void *user_data) {
  if (state->count == 1) {
    layer_on(_SYMBOL);
  } else {
    register_code(KC_RALT);
  }
}

void td_symb_ralt_reset(qk_tap_dance_state_t *state, void *user_data) {
  if (state->count == 1) {
    layer_off(_SYMBOL);
  } else {
    unregister_code(KC_RALT);
  }
}

qk_tap_dance_action_t tap_dance_actions[] = {
  [TD_ALT_GUI] = ACTION_TAP_DANCE_DOUBLE(KC_LALT, KC_LGUI),
  [TD_SFT_CAPS] = ACTION_TAP_DANCE_DOUBLE(KC_LSFT, KC_CAPS),
  [TD_SYMB_RALT] = ACTION_TAP_DANCE_FN_ADVANCED(NULL, td_symb_ralt_finished, td_symb_ralt_reset),
};

#define KC______ KC_TRNS
#define KC_XXXXX KC_NO
#define KC_MODMH MODMH
#define KC_SWEMK SWEMH
#define KC_QWERT QWERTY
#define KC_COLMK COLEMAK
#define KC_NAV TT(_NAVIGATION)
#define KC_LOWER TT(_LOWER)
#define KC_RAISE TT(_RAISE)
#define KC_RESET RESET
#define KC_DEBUG DEBUG
#define KC_INS KC_INSERT
#define KC_SFTEN RSFT_T(KC_ENT)
#define KC_ALTGU TD(TD_ALT_GUI)
#define KC_SFTCA TD(TD_SFT_CAPS)
#define KC_SYMRA TD(TD_SYMB_RALT)
#define KC_ALTF4 LALT(KC_F4)
#define KC_OE RALT(KC_P)
#define KC_AA RALT(KC_W)
#define KC_AE RALT(KC_Q)
#define KC_MSUP KC_MS_UP
#define KC_MSDN KC_MS_DOWN
#define KC_MSLT KC_MS_LEFT
#define KC_MSRT KC_MS_RIGHT
#define KC_MSLC KC_MS_BTN1
#define KC_MSMC KC_MS_BTN2
#define KC_MSRC KC_MS_BTN3
#define KC_SMIL X(SMIL)
#define KC_SMRK X(SMRK)
#define KC_JOY X(JOY)
#define KC_THNK X(THNK)
#define KC_THUM X(THUM)
#define KC_OK X(OK)
#define KC_WAVE X(WAVE)
#define KC_EYES X(EYES)
#define KC_UNIX UNICODE_MODE_LNX

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
  [_MODMH] = LAYOUT_kc( \
  //,-----------------------------------------.                ,-----------------------------------------.
        TAB,     Q,     W,     F,     P,     G,                      J,     L,     U,     Y,  SCLN,  BSPC, \
  //|------+------+------+------+------+------|                |------+------+------+------+------+------|
      LCTRL,     A,     R,     S,     T,     D,                      M,     N,     E,     I,     O,  QUOT, \
  //|------+------+------+------+------+------|                |------+------+------+------+------+------|
       LSFT,     Z,     X,     C,     V,     B,                      K,     H,  COMM,   DOT,  SLSH, SFTEN, \
  //|------+------+------+------+------+------+------|  |------+------+------+------+------+------+------|
                                  ALTGU,   SPC, LOWER,    RAISE, SYMRA,   NAV \
                              //`--------------------'  `--------------------'
  ),

  [_SWEMH] = LAYOUT_kc( \
  //,-----------------------------------------.                ,-----------------------------------------.
        TAB,     Q,     W,     F,     P,     G,                      J,     L,     U,     Y,    OE,    AA, \
  //|------+------+------+------+------+------|                |------+------+------+------+------+------|
      LCTRL,     A,     R,     S,     T,     D,                      M,     N,     E,     I,     O,    AE, \
  //|------+------+------+------+------+------|                |------+------+------+------+------+------|
       LSFT,     Z,     X,     C,     V,     B,                      K,     H,  COMM,   DOT,  SLSH, SFTEN, \
  //|------+------+------+------+------+------+------|  |------+------+------+------+------+------+------|
                                  ALTGU,   SPC, LOWER,    RAISE, SYMRA,   NAV \
                              //`--------------------'  `--------------------'
  ),

  [_QWERTY] = LAYOUT_kc( \
  //,-----------------------------------------.                ,-----------------------------------------.
        TAB,     Q,     W,     E,     R,     T,                      Y,     U,     I,     O,     P,  BSPC, \
  //|------+------+------+------+------+------|                |------+------+------+------+------+------|
      LCTRL,     A,     S,     D,     F,     G,                      H,     J,     K,     L,  SCLN,  QUOT, \
  //|------+------+------+------+------+------|                |------+------+------+------+------+------|
       LSFT,     Z,     X,     C,     V,     B,                      N,     M,  COMM,   DOT,  SLSH, SFTEN, \
  //|------+------+------+------+------+------+------|  |------+------+------+------+------+------+------|
                                  ALTGU,   SPC, LOWER,    RAISE, SYMRA,  NAV \
                              //`--------------------'  `--------------------'
  ),

  [_MELEE] = LAYOUT_kc( \
  //,-----------------------------------------.                ,-----------------------------------------.
         F5, XXXXX, XXXXX, XXXXX, XXXXX,     G,                  XXXXX,     H,     I, XXXXX, XXXXX, XXXXX, \
  //|------+------+------+------+------+------|                |------+------+------+------+------+------|
      XXXXX,     A,     B,     C,     D, XXXXX,                  XXXXX,     J,     K,     L,     M, XXXXX, \
  //|------+------+------+------+------+------|                |------+------+------+------+------+------|
      MODMH, XXXXX, XXXXX, XXXXX, XXXXX, XXXXX,                      O,     N, XXXXX, XXXXX, XXXXX, XXXXX, \
  //|------+------+------+------+------+------+------|  |------+------+------+------+------+------+------|
                                  XXXXX,     E,     F,        R,     Q,     P \
                              //`--------------------'  `--------------------'
  ),

  [_NAVIGATION] = LAYOUT_kc( \
  //,-----------------------------------------.                ,-----------------------------------------.
      _____, _____,  MSRC,  MSMC,  MSLC, _____,                  _____,  MPLY,  VOLD,  VOLU,  MNXT, _____, \
  //|------+------+------+------+------+------|                |------+------+------+------+------+------|
      _____,  MSLT,  MSUP,  MSDN,  MSRT, _____,                  _____,  LEFT,  DOWN,    UP,  RGHT, _____, \
  //|------+------+------+------+------+------|                |------+------+------+------+------+------|
      _____, _____, _____, _____, _____, _____,                  _____,  HOME,  PGDN,  PGUP,   END, _____, \
  //|------+------+------+------+------+------+------|  |------+------+------+------+------+------+------|
                                  _____, _____, _____,    _____, _____, _____ \
                              //`--------------------'  `--------------------'
  ),

  [_SYMBOL] = LAYOUT_kc( \
  //,-----------------------------------------.                ,-----------------------------------------.
      _____,  EXLM,    AT,  HASH,   DLR, _____,                  _____,  AMPR,  ASTR,  PERC,  CIRC,   DEL, \
  //|------+------+------+------+------+------|                |------+------+------+------+------+------|
      _____,  TILD,   GRV,  UNDS,  MINS, _____,                  _____,  PLUS,   EQL,  PIPE,  BSLS,   INS, \
  //|------+------+------+------+------+------|                |------+------+------+------+------+------|
      _____, _____,  LCBR,  LBRC,  LPRN, _____,                  _____,  RPRN,  RBRC,  RCBR, _____, _____, \
  //|------+------+------+------+------+------+------|  |------+------+------+------+------+------+------|
                                  _____, _____, _____,    _____, _____, _____ \
                              //`--------------------'  `--------------------'
  ),

  [_LOWER] = LAYOUT_kc( \
  //,-----------------------------------------.                ,-----------------------------------------.
        ESC,    F1,    F2,    F3,    F4,  PSCR,                  _____, ALTF4, _____, _____,  SCLN,  BSPC, \
  //|------+------+------+------+------+------|                |------+------+------+------+------+------|
      _____,    F5,    F6,    F7,    F8,  SLCK,                  _____,  SMIL,  SMRK,   JOY,  THNK,  QUOT, \
  //|------+------+------+------+------+------|                |------+------+------+------+------+------|
      _____,    F9,   F10,   F11,   F12,  PAUS,                   UNIX,  THUM,    OK,  WAVE,  EYES, _____, \
  //|------+------+------+------+------+------+------|  |------+------+------+------+------+------+------|
                                  RESET, _____, _____,    _____,  CAPS, _____ \
                              //`--------------------'  `--------------------'
  ),

  [_RAISE] = LAYOUT_kc( \
  //,-----------------------------------------.                ,-----------------------------------------.
      _____, _____, _____, _____, _____, _____,                   PSLS,     7,     8,     9,  PMNS, _____, \
  //|------+------+------+------+------+------|                |------+------+------+------+------+------|
      _____, _____, _____, _____, _____, _____,                   PDOT,     4,     5,     6,     0,  NLCK, \
  //|------+------+------+------+------+------|                |------+------+------+------+------+------|
      _____, _____, _____, _____, _____, _____,                   PAST,     1,     2,     3,  PPLS, _____, \
  //|------+------+------+------+------+------+------|  |------+------+------+------+------+------+------|
                                  _____, _____, _____,    _____,     0, RESET \
                              //`--------------------'  `--------------------'
  ),

  [_ADJUST] = LAYOUT_kc( \
  //,-----------------------------------------.                ,-----------------------------------------.
      DEBUG, _____, _____, _____, _____, _____,                  _____, _____, _____, _____, _____, _____, \
  //|------+------+------+------+------+------|                |------+------+------+------+------+------|
      _____, COLMK, QWERT, SWEMK, MODMH, _____,                  _____, _____, _____, _____, _____, _____, \
  //|------+------+------+------+------+------|                |------+------+------+------+------+------|
      _____, _____, _____, _____, _____, _____,                  _____, _____, _____, _____, _____, _____, \
  //|------+------+------+------+------+------+------|  |------+------+------+------+------+------+------|
                                  _____, _____, _____,    _____, _____, _____ \
                              //`--------------------'  `--------------------'
  )
};

layer_state_t layer_state_set_user(layer_state_t state) {
  layer_state_t new_state = update_tri_layer_state(state, _LOWER, _RAISE, _ADJUST);
  return new_state;
}


bool process_record_user(uint16_t keycode, keyrecord_t *record) {
  switch (keycode) {
    case MODMH:
      if (record->event.pressed) {
        set_single_persistent_default_layer(_MODMH);
      }
      return false;
    case SWEMH:
      if (record->event.pressed) {
        set_single_persistent_default_layer(_SWEMH);
      }
      return false;
    case QWERTY:
      if (record->event.pressed) {
        set_single_persistent_default_layer(_QWERTY);
      }
      return false;
    case COLEMAK:
      if (record->event.pressed) {
        set_single_persistent_default_layer(_MELEE);
      }
      return false;
    case NAVIGATION:
      if (record->event.pressed) {
        layer_on(_NAVIGATION);
      } else {
        layer_off(_NAVIGATION);
      }
      return false;
    case SYMBOL:
      if (record->event.pressed) {
        layer_on(_SYMBOL);
      } else {
        layer_off(_SYMBOL);
      }
      return false;
    default:
      return true;
  }
}
