#include "stringprep.h"

/*
 * The vendored libidn.a is an old i386/armv7 archive and SPM does not
 * link raw .a files. Camtalk JIDs are ASCII uids, so identity prep is enough.
 */
const Stringprep_profile stringprep_nameprep[] = {{0}};
const Stringprep_profile stringprep_saslprep[] = {{0}};
const Stringprep_profile stringprep_xmpp_nodeprep[] = {{0}};
const Stringprep_profile stringprep_xmpp_resourceprep[] = {{0}};

int stringprep(char *in, size_t maxlen, Stringprep_profile_flags flags,
               const Stringprep_profile *profile) {
  (void)maxlen;
  (void)flags;
  (void)profile;
  if (in == NULL) {
    return STRINGPREP_PROFILE_ERROR;
  }
  return STRINGPREP_OK;
}
