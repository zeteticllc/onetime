#include <stdio.h>
#include <unistd.h>

#include <ykpers.h>
#include <yubikey.h>
#include <ykdef.h>

//                            0 1  2   3    4     5      6       7        8
const int digits_power[9] = { 1,10,100,1000,10000,100000,1000000,10000000,100000000 };

const char *usage =
	"Usage: totpy [options]\n"
	"\n"
	"Options :\n"
	"\n"
	"\t-1          Send challenge to slot 1. This is the default.\n"
	"\t-2          Send challenge to slot 2.\n"
	"\t-N          Abort if Yubikey requires button press.\n"
	"\t-d digits   Output TOTP length (default 6 digits).\n"
	"\t-s step     Time Step in seconds (default 30).\n"
	"\n"
	"\t-v          verbose\n"
	"\t-h          help (this text)\n"
	"\n"
	"\n"
	;
const char *optstring = "12vhNd:s:";

static void report_yk_error()
{
	if (ykp_errno)
		fprintf(stderr, "Yubikey personalization error: %s\n",
			ykp_strerror(ykp_errno));
	if (yk_errno) {
		if (yk_errno == YK_EUSBERR) {
			fprintf(stderr, "USB error: %s\n",
				yk_usb_strerror());
		} else {
			fprintf(stderr, "Yubikey core error: %s\n",
				yk_strerror(yk_errno));
		}
	}
}

int parse_args(int argc, char **argv,
	       int *slot, int *digits, int *step, bool *verbose,
	       bool *may_block, 
	       int *exit_code)
{
	int c;

	while((c = getopt(argc, argv, optstring)) != -1) {
		switch (c) {
		case '1':
			*slot = 1;
			break;
		case '2':
			*slot = 2;
			break;
		case 'd':
			*digits = atoi(optarg);
			break;
		case 's':
			*step = atoi(optarg);
			break;
		case 'N':
			*may_block = false;
			break;
		case 'v':
			*verbose = true;
			break;
		case 'h':
		default:
			fputs(usage, stderr);
			*exit_code = 0;
			return 0;
		}
	}

	return 1;
}

int check_firmware(YK_KEY *yk, bool verbose)
{
	YK_STATUS *st = ykds_alloc();

	if (!yk_get_status(yk, st)) {
		free(st);
		return 0;
	}

	if (verbose) {
		printf("Firmware version %d.%d.%d\n",
		       ykds_version_major(st),
		       ykds_version_minor(st),
		       ykds_version_build(st));
		fflush(stdout);
	}

	if (ykds_version_major(st) < 2 ||
	    (ykds_version_major(st) == 2
	     && ykds_version_minor(st) < 2)) {
		fprintf(stderr, "Challenge-response not supported before YubiKey 2.2.\n");
		free(st);
		return 0;
	}

	free(st);
	return 1;
}

inline void to_big_endian(unsigned long *xp)
{
    *xp = (*xp>>56) | 
        ((*xp<<40) & 0x00FF000000000000) |
        ((*xp<<24) & 0x0000FF0000000000) |
        ((*xp<<8)  & 0x000000FF00000000) |
        ((*xp>>8)  & 0x00000000FF000000) |
        ((*xp>>24) & 0x0000000000FF0000) |
        ((*xp>>40) & 0x000000000000FF00) |
        (*xp<<56);
}

int challenge_response(YK_KEY *yk, int slot, int digits, int step,
		       bool may_block, bool verbose)
{
	unsigned char response[64];
	unsigned char output_buf[(SHA1_MAX_BLOCK_SIZE * 2) + 1];
	int yk_cmd;
	unsigned int flags = 0;
	unsigned int response_len = 0;
	unsigned int expect_bytes = 0;
	int interval = 30;
	unsigned int offset, raw_otp, otp;
	unsigned char challenge[SHA1_MAX_BLOCK_SIZE];
	unsigned int challenge_len;

	unsigned long moving_factor;

	memset(challenge, 0, sizeof(challenge));
	
	time_t t = time(NULL);
	moving_factor = t / step;

	if(verbose) {
		printf("number of seconds since epoch: %ld\n", t);
		printf("moving factor with step=%d: %ld\n", step, moving_factor);
	}

	to_big_endian(&moving_factor); // convert to big endian

	memcpy(challenge, &moving_factor, sizeof(moving_factor));
	challenge_len = sizeof(moving_factor);

	// for testing against rfc6238	
	//char *time_hex = "0000000000000001"; 
	//yubikey_hex_decode(challenge, time_hex, sizeof(challenge));
	//challenge_len = 8;

	memset(response, 0, sizeof(response));

	if (may_block)
		flags |= YK_FLAG_MAYBLOCK;

	if (verbose) {
		fprintf(stderr, "Sending %i bytes %s challenge to slot %i\n", challenge_len, "HMAC", slot);
		_yk_hexdump(challenge, challenge_len);
	}

	yk_cmd = (slot == 1) ? SLOT_CHAL_HMAC1 : SLOT_CHAL_HMAC2;

	if (!yk_write_to_key(yk, yk_cmd, challenge, challenge_len))
		return 0;

	if (verbose) {
		fprintf(stderr, "Reading response...\n");
	}

	/* HMAC responses are 160 bits */
	expect_bytes = 20;

	if (! yk_read_response_from_key(yk, slot, flags,
					&response, sizeof(response),
					expect_bytes,
					&response_len))
		return 0;

	if (response_len > expect_bytes)
		response_len = expect_bytes;

	offset = response[response_len-1] & 0xf;

	raw_otp =  (
 		(response[offset]&0x7f) << 24 |
		(response[offset+1]&0xff) << 16 |
		(response[offset+2]&0xff) << 8 |
		(response[offset+3]&0xff));

	otp = raw_otp % digits_power[digits];

	if(verbose) {
		memset(output_buf, 0, sizeof(output_buf));
		yubikey_hex_encode(output_buf, (char *)response, response_len);
		printf("raw hmac: %s\n", output_buf);
		printf("offset: %d\n", offset);
		printf("raw otp: %d\n", otp);
		printf("digits power[%d]: %d\n", digits, digits_power[digits]);
	}

	printf("otp: %d\n", otp);

	return 1;
}

int main(int argc, char **argv)
{
	YK_KEY *yk = 0;
	bool error = true;
	int exit_code = 0;

	/* Options */
	bool verbose = false;
	bool may_block = true;
	
	int slot = 1;

	int digits = 6; // default to 6 digit OTP output
        int step = 30; // defaultto 30 second step 

	ykp_errno = 0;
	yk_errno = 0;

	if (! parse_args(argc, argv,
			 &slot, &digits, &step, &verbose,
			 &may_block,
			 &exit_code))
		goto err;

	if (!yk_init()) {
		exit_code = 1;
		goto err;
	}

	if (!(yk = yk_open_first_key())) {
		exit_code = 1;
		goto err;
	}

	if (! check_firmware(yk, verbose)) {
		exit_code = 1;
		goto err;
	}

	if (! challenge_response(yk, slot, digits, step,
				 may_block, verbose)) {
		exit_code = 1;
		goto err;
	}

	exit_code = 0;
	error = false;

err:
	if (error || exit_code != 0) {
		report_yk_error();
	}

	if (yk && !yk_close_key(yk)) {
		report_yk_error();
		exit_code = 2;
	}

	if (!yk_release()) {
		report_yk_error();
		exit_code = 2;
	}

	exit(exit_code);
}
