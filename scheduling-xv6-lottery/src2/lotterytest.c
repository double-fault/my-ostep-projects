// testing that the lottery scheduler is doing its job
#include "types.h"
#include "stat.h"
#include "user.h"
#include "param.h"
#include "pstat.h"

void error() {
	printf(1, "some error occurred\n");
	exit();
}

int main (int argc, char **argv) {
	int rc = fork();
	if (rc < 0) error();
	if (rc == 0) {
		// inf loop
		printf(1, "3 tickets with process %d\n", getpid());
		settickets(3);
		for (;;) ;
	}

	rc = fork();
	if (rc < 0) error();
	if (rc == 0) {
		printf(1, "2 tickets with process %d\n", getpid());
		settickets(2);
		for (;;) ;
	}

	rc = fork();
	if (rc < 0) error();
	if (rc == 0) {
		printf(1, "1 ticket with process %d\n", getpid());
		settickets(1);
		for (;;) ;
	}

	while (1) {
		sleep(300);
		struct pstat st;
		if (getpinfo(&st) < 0) error();
		printf(1, "\n");
		for (int i = 0; i < NPROC; ++i) {
		       if (st.inuse[i]) {
			       printf(1, "PID: %d, tickets: %d, ticks: %d\n", st.pid[i], st.tickets[i], st.ticks[i]);
		       }
		}
	}
	exit();
}

