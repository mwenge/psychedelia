"""
    Purpose: To run through some simple examples of ASCII to PETSCII and 
             return conversions
"""


from ATPC import *


def examples():
    """
    Purpose: runs through some simple examples
    Input: nothing
    Output: Side effect is that things are printed to the screen
    """
    logging.info("Lets Run some Test cases")
    print("\n\nKEEP IN MIND THAT THE RETURN VALUE IS JUST AN INTEGER")
    print("")
    print("String 'HI THERE A' to petscii: " + str(asc_to_pet_s("HI THERE A")))
    print("String 'hi there a' to petscii: " + str(asc_to_pet_s("hi there a")))
    print ("Seems Wrong, but its actually correct since input is actually in ascii, not petscii")
    print("String 'HI THERE A' to ascii: " +  str(pet_to_asc_s('HI THERE A')))
    print("String 'hi there a' to ascii: " +  str(pet_to_asc_s('hi there a')))
    print ("")
    print ("Lets get some petscii bytes of a 'HI THERE' ascii string")
    pet_bytes = asc_to_pet_s("HI THERE")
    print "Got back petscii %s" % pet_bytes
    print "Now lets translate the petscii bytes to ascii bytes"
    tr_msg = ''
    for byte in pet_bytes:
        b_trans = pet_to_asc_b(byte)
        tr_msg = '%s%s' % (tr_msg, chr(b_trans))
        #print "From petscii %s we got back ascii %s which as a character is %s"%(b,b_trans,chr(b_trans))
    print ("From ascii Translated to petscii %s" % tr_msg)
    print ("")
    print "Great it works lets try a different ascii string 'hi there' of lower characters"
    pet_bytes = asc_to_pet_s("hi there")
    print "Got back petscii %s" % pet_bytes
    print ("")
    tr_msg = ''
    print ("Now lets translate the petscii bytes to ascii bytes")
    for byte in pet_bytes:
        b_trans = pet_to_asc_b(byte)
        tr_msg = '%s%s' % (tr_msg, chr(b_trans))
        #print "From petscii %s we got back ascii %s which as a character is %s"%(b,b_trans,chr(b_trans))
    print("From ascii Translated to petscii %s" % tr_msg)
    print("")
    print("Lets get some ascii bytes of a 'HI THERE' ascii string")
    #asc_bytes=pet_to_asc_s("hi there")
    msg = "HI THERE"
    asc_bytes = get_bytes(msg)
    print("Got back ascii %s" % asc_bytes)
    print("Now lets translate the ascii bytes to petcii bytes")
    tr_msg = ''
    for byte in asc_bytes:
        b_trans = asc_to_pet_b(byte)
        tr_msg = '%s%s' % (tr_msg, chr(b_trans))
        #print "From ascii %s we got back petscii %s which as a character is %s"%(b,b_trans,chr(b_trans))
    print("From ascii Translated to petscii %s" % tr_msg)
    print("")
    print("Great it works lets try a different ascii string 'hi there' of lower characters")
    msg = "hi there"
    asc_bytes = [ord(elem) for elem in msg]
    print("Got back ascii %s" % asc_bytes)
    print("Now lets translate the ascii bytes to petcii bytes")
    tr_msg = ''
    for byte in asc_bytes:
        b_trans = asc_to_pet_b(byte)
        tr_msg = '%s%s' % (tr_msg, chr(b_trans))
        #print "From ascii %s we got back petscii %s which as a character is %s"%(b,b_trans,chr(b_trans))
    print("From ascii Translated to petscii %s" % tr_msg)
    print("")
    print("this is the behaviour i would expect ... thanks andi")
    print("")
    print("")
    print("Lets try some byte arrays")
    msg = "hi there"
    asc_bytes = [ord(elem) for elem in msg]
    print("Got back ascii %s"%asc_bytes)
    print ("Now lets translate the ascii bytes to petcii bytes")
    tr_msg = ''
    pet_bytes = asc_to_pet_b_arr(asc_bytes)
    
    for byte in pet_bytes:
    #    b_trans = asc_to_pet_b(b)
        tr_msg = '%s%s' % (tr_msg, chr(byte))
        #print "From ascii %s we got back petscii %s which as a character is %s"%(b,b_trans,chr(b_trans))
    print("From ascii Translated to petscii %s" % tr_msg)
    print("")
    print("")
    print("Lets try function overloading")
    print("String 'HI THERE A' to ascii(String): " + str(pet_to_asc_s("HI THERE A",result_type='string')))
    print("String 'HI THERE A' to ascii(String) again: " + str(pet_to_asc_s('HI THERE A',result_type='string')))
    print("String 'hi there a' to ascii(String): " + str(pet_to_asc_s("hi there a",result_type='string')))
    print("String 'HI THERE A' to petscii(String): " + str(asc_to_pet_s("HI THERE A",result_type='string')))
    print("String 'hi there a' to petscii(String): " + str(asc_to_pet_s("hi there a",result_type='string')))
    print("")
    print("")
    print("Lets try more function overloading")
    print("get string (as ascii) from string(as pet) using 'ALL CAPS'")
    print(pet_to_asc_b_arr(get_bytes("ALL CAPS"),result_type='string'))
    print("get string (as ascii) from string(as pet) using 'no caps'")
    print(pet_to_asc_b_arr(get_bytes("no caps"),result_type='string'))
    print("get string (as petscii) from string(as asc) using 'ALL CAPS'")
    print(asc_to_pet_b_arr(get_bytes("ALL CAPS"),result_type='string'))
    print("get string (as ascii) from string(as pet) using 'no caps'")
    print(asc_to_pet_b_arr(get_bytes("no caps"),result_type='string'))
    
    
examples()
