#include <stdio.h>
#include <unistd.h>

#include "totp.h"

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

	if (! totp_challenge(yk, slot, digits, step,
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
