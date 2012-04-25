#include <yubikey.h>
#include <ykpers.h>
#include <ykdef.h>

int check_firmware(YK_KEY *yk, bool verbose);
void to_big_endian(unsigned long *xp);
int totp_challenge(YK_KEY *yk, int slot, int digits, int step,
		       bool may_block, bool verbose, unsigned int *result);
