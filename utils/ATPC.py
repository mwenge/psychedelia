"""
Created on Jul 28, 2015

@author: andi bergen

Purpose: Convert single character of ASCII to PETSCII and vice versa.
         Also converts string of ASCII to list of hex PETSCII values.
"""

import tables
import logging

logging.basicConfig(filename='conv.log', level=logging.DEBUG)

def pet_to_asc_b_arr(in_bytes, result_type='default'):
    """
    Purpose: converts PETSCII bytes to ASCII
    Input: array of bytes
    Output: returns hex array of ASCII bytes or a string (ascii)
            representation of bytes
    """
    ret = []
    ret_str = ''
    for b in in_bytes:
        ret.append(pet_to_asc_b(b))
        ret_str = "%s%s" % (ret_str, chr(pet_to_asc_b(b)))
    if result_type == 'default':
        return ret
    else:
        return ret_str


def pet_to_asc_b(in_byte, result_type='default'):
    """
    Purpose: converts PETSCII byte/unicode to ASCII
    Input: single byte/hex value
    Output: returns hex value of ASCII character or character
    """
    ret = tables.petToAscTable[in_byte]
    logging.debug("petscii byte: %s to %s" % (in_byte, ret))
    if result_type == 'default':
        return ret
    else:
        return chr(ret)


def asc_to_pet_b_arr(in_bytes, result_type='default'):
    """
    Purpose: converts ASCII bytes to PETSCII
    Input: array of bytes
    Output: returns hex array of PETSCII bytes or a string (which will
            be in ascii rep. but petscii byte) representation of bytes
    """
    ret = []
    ret_str = ''
    for b in in_bytes:
        ret.append(asc_to_pet_b(b))
        ret_str = "%s%s" % (ret_str, chr(asc_to_pet_b(b)))
    if result_type == 'default':
        return ret
    else:
        return ret_str


def asc_to_pet_b(in_byte,result_type='default'):
    """
    Purpose: converts PETSCII byte/unicode to ASCII
    Input: single byte/hex value
    Output: returns hex value of ASCII character or character
    """
    ret = tables.ascToPetTable[in_byte]
    logging.debug("ascii byte: %s to %s" % (in_byte, ret))
    if result_type == 'default':
        return ret
    else:
        return chr(ret)


def pet_to_asc_c(in_char, result_type='default'):
    """
    Purpose: converts PETSCII character to ASCII
    Input: single character/hex value
    Output: returns hex value of ASCII character
    """
    logging.debug("in petToAscC %s " % in_char)
    if len(in_char) != 1:
        logging.warning("in pet_to_asc_c")
        logging.warning("you are calling the wrong function")
        logging.warning("parameter should be a single character")
        return -1
    ret = tables.petToAscTable[ord(in_char)]
    logging.debug("pet character: " + str(ord(in_char)) + " to " + str(chr(ret)))
    if result_type == 'default':
        return ret
    else:
        return chr(ret)


def pet_to_asc_s(in_str, result_type='default'):
    """
    Purpose: converts PETSCII string to ASCII
    Input: PETSCII string
    Output: returns list of hex values of ASCII characters or an Ascii
            String representation
    """
    # not sure if you need this or what you'd pass in
    logging.debug("in pet_to_asc_s " + str(in_str))
    ret = []
    ret_str = ''
    for in_char in in_str:
        ret.append(pet_to_asc_c(in_char))
        ret_str = "%s%s" % (ret_str, chr(pet_to_asc_c(in_char)))
    if result_type == 'default':
        return ret
    else:
        return ret_str


def asc_to_pet_c(in_char, result_type='default'):
    """
    Purpose: converts ASCII character to PETSCII
    Input: single character/hex value
    Output: returns hex value of PETSCII character
    """
    logging.debug("in asc_to_pet_c")
    if len(in_char) != 1:
        logging.warning("in asc_to_pet_c")
        logging.warning("you are calling the wrong function")
        logging.warning("parameter should be a single character")
        return -1
    ret = tables.ascToPetTable[ord(in_char)]
    logging.debug("ascii character: " + str(in_char) + " to " + str(ret))
    if result_type == 'default':
        return ret
    else:
        return chr(ret)


def asc_to_pet_s(in_str, result_type='default'):
    """
    Purpose: converts ASCII string to list of PETSCII hex values
    Input: ASCII string
    Output: returns list of hex values of PETSCII characters or an Ascii
    String representation
    """
    logging.debug("in asc_to_pet_s")
    ret = []
    ret_str = ''
    for in_char in in_str:
        ret.append(asc_to_pet_c(in_char))
        ret_str = "%s%s" % (ret_str, chr(asc_to_pet_c(in_char)))
    if result_type == 'default':
        return ret
    else:
        return ret_str


def get_bytes(msg_str):
    """
    Purpose: extra utility
    Input: Message string
    Output: Returns byte value for each element in the message
    """
    return [ord(elem) for elem in msg_str]
