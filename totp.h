#include <ykpers.h>
#include <yubikey.h>
#include <ykdef.h>

int check_firmware(YK_KEY *yk, bool verbose);
int totp_challenge(YK_KEY *yk, int slot, int digits, int step,
		       bool may_block, bool verbose);
