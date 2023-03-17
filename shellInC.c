#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[]) {
    if (argc != 2) {
        printf("Usage: %s <file>\n", argv[0]);
        exit(1);
    }

    char *file = argv[1];
    system("echo '' > url_bash");
    char cmd1[100];
    sprintf(cmd1, "awk '/\" 4[0-9][0-9] / { print $7 }' %s > url_bash", file);
    system(cmd1);
    system("cat url_bash | sort | uniq -c | sort -nr > url_link");
    system("awk '{print $1}' url_link > url_amount");

    FILE *fp = fopen("url_amount", "r");
    int sum = 0;
    int count;
    while (fscanf(fp, "%d", &count) == 1) {
        sum += count;
    }
    fclose(fp);

    char cmd2[200];
    sprintf(cmd2, "awk  -v s=%d 'BEGIN{ ans = s} {print $2 \" - \" $1 \" -  \" $1*100/s \"%%\" }' url_link | head -n 10 | nl -s'.'", sum);
    system(cmd2);

    return 0;
}

