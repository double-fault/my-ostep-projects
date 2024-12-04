/*
 * main.c
 * created on dec 4 2024
 *
 * ostep processes-shell project: a basic shell using fork + exec
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <fcntl.h>
#include <sys/wait.h>

void print_error() {
	char error_message[30] = "An error has occurred\n";
	write(STDERR_FILENO, error_message, strlen(error_message));
}

// destroys given string, all memory is freed
char** parse_input(char *input, int *cnt) {
	*cnt = 0;
	char **parsed = NULL;

	char *cp = input;
	while (input != NULL && input[0] != '\0' && input[0] != '\n') {
		if (input[0] == ' ' || input[0] == '\t') {
			++input;
			continue;
		}
		char *token = strsep(&input, "\n ");
		(*cnt)++;
		parsed = realloc(parsed, sizeof(char*) * (*cnt));
		parsed[(*cnt) - 1] = strdup(token);
	}
	free(cp);

	return parsed;
}

int path_cnt = 0;
char **paths;

pid_t execute_cmd(int n, char **cmds) {
	int redrn = -1;
	for (int i = 0; i < n; ++i) {
		if (!strcmp(cmds[i], ">")) {
			if (redrn != -1) {
				return -1;
			}
			redrn = i;
		}
	}

	if (redrn != n - 2 && redrn != -1) {
		return -1;
	}

	if (redrn != -1 && n <= 2) {
		return -1;
	}

	for (int i = 0; i < path_cnt; ++i) {
		char *tmp = malloc(sizeof(char) * (strlen(paths[i]) + strlen(cmds[0]) + 2));
		tmp[0] = '\0';
		tmp = strcat(tmp, paths[i]); tmp = strcat(tmp, "/"); tmp = strcat(tmp, cmds[0]);

		if (access(tmp, X_OK) == 0) {
			pid_t rc = fork();
			if (rc < 0) {
				return rc;
			} else if (rc == 0) {
				if (redrn != -1) {
					close(STDOUT_FILENO); close(STDERR_FILENO);
					open(cmds[n - 1], O_CREAT|O_WRONLY|O_TRUNC, S_IRWXU);
					open(cmds[n - 1], O_CREAT|O_WRONLY|O_TRUNC, S_IRWXU);
					cmds[n - 2] = NULL;
				} else cmds = realloc(cmds, sizeof(char*) * (n + 1)); cmds[n] = NULL;
				execv(tmp, cmds);
				exit(0); // returns to this only if execv had an error
			} else {
				// back in parent
				free(tmp);
				return rc;
			}
		}
		free(tmp);
	}
	return -1;
}

void pre_process(int n, char **cmds) {
	int prv = 0;
	int chd_cnt = 0;
	while (prv < n) {
		int cur = prv;
		while (cur <= n) {
			if (cur == n || !strcmp(cmds[cur], "&")) {
				if (cur == prv) {
					print_error();
					return;
				}
				int m = cur - prv;
				char **tp = malloc(sizeof(char*) * m);
				for (int i = prv; i < cur; ++i) tp[i - prv] = strdup(cmds[i]); 
				
				if (execute_cmd(m, tp) != -1)
					chd_cnt++;
				else {
					print_error();
					return;
				}

				for (int i = 0; i < m; ++i) free(tp[i]); 
				free(tp);

				break;
			}
			cur++;
		}
		prv = cur + 1;
	}

	while (chd_cnt--) wait(NULL);
}

int main(int argc, char **argv) {
	if (argc > 2) {
		print_error();
		exit(1);
	}

	// Add /bin to path
	paths = realloc(paths, sizeof(char*) * (++path_cnt));
	paths[0] = strdup("/bin");

	int batch = 0;
	FILE *stream = stdin;
	if (argc == 2) {
		batch = 1;
		stream = fopen(argv[1], "r");
	}

	int found = 0;
	while(1) {
		if (!batch) printf("wish> ");
		char *inp = NULL; size_t sz = 0;
		if (getline(&inp, &sz, stream) == -1) break;

		int n;
		char **cmds = parse_input(inp, &n); 

		if (n == 0) continue;
		found = 1;

		if (!strcmp(cmds[0], "exit")) {
			if (n > 1) print_error();
			else exit(0);
		} else if (!strcmp(cmds[0], "cd")) {
			if (n != 2) print_error();
			else {
				if (chdir(cmds[1]) == -1) print_error();
			}
		} else if (!strcmp(cmds[0], "path")) {
			for (int i = 0; i < path_cnt; ++i) free(paths[i]);
			path_cnt = n - 1;
			paths = realloc(paths, sizeof(char*) * path_cnt); 
			for (int i = 0; i < path_cnt; ++i) paths[i] = strdup(cmds[i + 1]);
		} else {
			pre_process(n, cmds);
		}

		for (int i = 0; i < n; ++i) free(cmds[i]);
		free(cmds);
	}
	if (!found) print_error();

	return 0;
}


