
_protecttest:     file format elf32-i386


Disassembly of section .text:

00001000 <main>:
#include "user.h"
#include "fs.h"

int
main(int argc, char *argv[])
{
    1000:	8d 4c 24 04          	lea    0x4(%esp),%ecx
    1004:	83 e4 f0             	and    $0xfffffff0,%esp
    1007:	ff 71 fc             	push   -0x4(%ecx)
    100a:	55                   	push   %ebp
    100b:	89 e5                	mov    %esp,%ebp
    100d:	53                   	push   %ebx
    100e:	51                   	push   %ecx
  int pid = getpid();
    100f:	e8 6f 04 00 00       	call   1483 <getpid>

  printf(1, "If you don't see a \"test failed\" somewhere, then it succeeds. Page fault is trap 14.\n");
    1014:	83 ec 08             	sub    $0x8,%esp
    1017:	68 98 18 00 00       	push   $0x1898
  int pid = getpid();
    101c:	89 c3                	mov    %eax,%ebx
  printf(1, "If you don't see a \"test failed\" somewhere, then it succeeds. Page fault is trap 14.\n");
    101e:	6a 01                	push   $0x1
    1020:	e8 4b 05 00 00       	call   1570 <printf>

  int *p = (int*)0x1000;
  *p = 69;
    1025:	c7 05 00 10 00 00 45 	movl   $0x45,0x1000
    102c:	00 00 00 
  printf(1, "[pid %d] value at 0x1000: %d\n", pid, *p);
    102f:	6a 45                	push   $0x45
    1031:	53                   	push   %ebx
    1032:	68 eb 19 00 00       	push   $0x19eb
    1037:	6a 01                	push   $0x1
    1039:	e8 32 05 00 00       	call   1570 <printf>

  if (mprotect((void*)p, 3) < 0) {
    103e:	83 c4 18             	add    $0x18,%esp
    1041:	6a 03                	push   $0x3
    1043:	68 00 10 00 00       	push   $0x1000
    1048:	e8 56 04 00 00       	call   14a3 <mprotect>
    104d:	83 c4 10             	add    $0x10,%esp
    1050:	85 c0                	test   %eax,%eax
    1052:	78 5e                	js     10b2 <main+0xb2>
    printf(1, "[pid %d] test failed\n", pid);
    exit();
  }

  printf(1, "[pid %d] 3 pages starting at 0x1000 protected.\n", pid);
    1054:	50                   	push   %eax
    1055:	53                   	push   %ebx
    1056:	68 f0 18 00 00       	push   $0x18f0
    105b:	6a 01                	push   $0x1
    105d:	e8 0e 05 00 00       	call   1570 <printf>

  int rc = fork();
    1062:	e8 94 03 00 00       	call   13fb <fork>
  if (rc < 0) {
    1067:	83 c4 10             	add    $0x10,%esp
    106a:	85 c0                	test   %eax,%eax
    106c:	78 31                	js     109f <main+0x9f>
    printf(1, "test failed\n");
    exit();
  } else if (rc > 0) {
    106e:	74 1f                	je     108f <main+0x8f>
    printf(1, "[pid %d] child is %d, exiting.\n", pid, rc);
    1070:	50                   	push   %eax
    1071:	53                   	push   %ebx
    1072:	68 20 19 00 00       	push   $0x1920
    1077:	6a 01                	push   $0x1
    1079:	e8 f2 04 00 00       	call   1570 <printf>
    if (wait() < 0) 
    107e:	e8 88 03 00 00       	call   140b <wait>
    1083:	83 c4 10             	add    $0x10,%esp
    1086:	85 c0                	test   %eax,%eax
    1088:	78 71                	js     10fb <main+0xfb>
            printf(1, "[pid %d] test failed.\n", pid);
    exit();
    108a:	e8 74 03 00 00       	call   1403 <exit>
  }

  pid = getpid();
    108f:	e8 ef 03 00 00       	call   1483 <getpid>
    1094:	89 c3                	mov    %eax,%ebx

  rc = fork();
    1096:	e8 60 03 00 00       	call   13fb <fork>
  if (rc < 0) {
    109b:	85 c0                	test   %eax,%eax
    109d:	79 26                	jns    10c5 <main+0xc5>
    printf(1, "test failed\n");
    109f:	50                   	push   %eax
    10a0:	50                   	push   %eax
    10a1:	68 12 1a 00 00       	push   $0x1a12
    10a6:	6a 01                	push   $0x1
    10a8:	e8 c3 04 00 00       	call   1570 <printf>
    exit();
    10ad:	e8 51 03 00 00       	call   1403 <exit>
    printf(1, "[pid %d] test failed\n", pid);
    10b2:	50                   	push   %eax
    10b3:	53                   	push   %ebx
    10b4:	68 09 1a 00 00       	push   $0x1a09
    10b9:	6a 01                	push   $0x1
    10bb:	e8 b0 04 00 00       	call   1570 <printf>
    exit();
    10c0:	e8 3e 03 00 00       	call   1403 <exit>
    printf(1, "test failed\n");
    exit();
  } else if (rc == 0) {
    10c5:	75 4a                	jne    1111 <main+0x111>
    pid = getpid();
    10c7:	e8 b7 03 00 00       	call   1483 <getpid>
    printf(1, "[pid %d] trying to write at 0x3001, should cause a page fault.\n", pid);
    10cc:	51                   	push   %ecx
    pid = getpid();
    10cd:	89 c3                	mov    %eax,%ebx
    printf(1, "[pid %d] trying to write at 0x3001, should cause a page fault.\n", pid);
    10cf:	50                   	push   %eax
    10d0:	68 40 19 00 00       	push   $0x1940
    10d5:	6a 01                	push   $0x1
    10d7:	e8 94 04 00 00       	call   1570 <printf>
    p = (int*) 0x3001;
    *p = 69;
    10dc:	c7 05 01 30 00 00 45 	movl   $0x45,0x3001
    10e3:	00 00 00 
  printf(1, "[pid %d] writing to 0x2FFF should cause a page fault.\n", pid);

  p = (int*) 0x2FFF;
  *p = 69;

  printf(1, "[pid %d] test failed.\n", pid);
    10e6:	83 c4 0c             	add    $0xc,%esp
    10e9:	53                   	push   %ebx
    10ea:	68 1f 1a 00 00       	push   $0x1a1f
    10ef:	6a 01                	push   $0x1
    10f1:	e8 7a 04 00 00       	call   1570 <printf>

  exit();
    10f6:	e8 08 03 00 00       	call   1403 <exit>
            printf(1, "[pid %d] test failed.\n", pid);
    10fb:	50                   	push   %eax
    10fc:	53                   	push   %ebx
    10fd:	68 1f 1a 00 00       	push   $0x1a1f
    1102:	6a 01                	push   $0x1
    1104:	e8 67 04 00 00       	call   1570 <printf>
    1109:	83 c4 10             	add    $0x10,%esp
    110c:	e9 79 ff ff ff       	jmp    108a <main+0x8a>
    printf(1, "[pid %d] child is %d\n", pid, rc);
    1111:	50                   	push   %eax
    1112:	53                   	push   %ebx
    1113:	68 36 1a 00 00       	push   $0x1a36
    1118:	6a 01                	push   $0x1
    111a:	e8 51 04 00 00       	call   1570 <printf>
  if (munprotect((void*)0x3000, 4) < 0) {
    111f:	58                   	pop    %eax
    1120:	5a                   	pop    %edx
    1121:	6a 04                	push   $0x4
    1123:	68 00 30 00 00       	push   $0x3000
    1128:	e8 7e 03 00 00       	call   14ab <munprotect>
    112d:	83 c4 10             	add    $0x10,%esp
    1130:	85 c0                	test   %eax,%eax
    1132:	78 50                	js     1184 <main+0x184>
  printf(1, "[pid %d] trying to write at 0x3001, should work.\n", pid);
    1134:	51                   	push   %ecx
    1135:	53                   	push   %ebx
    1136:	68 80 19 00 00       	push   $0x1980
    113b:	6a 01                	push   $0x1
    113d:	e8 2e 04 00 00       	call   1570 <printf>
  *p = 69;
    1142:	c7 05 01 30 00 00 45 	movl   $0x45,0x3001
    1149:	00 00 00 
  printf(1, "[pid %d] value at 0x3001: %d\n", pid, *p);
    114c:	6a 45                	push   $0x45
    114e:	53                   	push   %ebx
    114f:	68 4c 1a 00 00       	push   $0x1a4c
    1154:	6a 01                	push   $0x1
    1156:	e8 15 04 00 00       	call   1570 <printf>
  if (wait() < 0) 
    115b:	83 c4 20             	add    $0x20,%esp
    115e:	e8 a8 02 00 00       	call   140b <wait>
    1163:	85 c0                	test   %eax,%eax
    1165:	78 30                	js     1197 <main+0x197>
  printf(1, "[pid %d] writing to 0x2FFF should cause a page fault.\n", pid);
    1167:	50                   	push   %eax
    1168:	53                   	push   %ebx
    1169:	68 b4 19 00 00       	push   $0x19b4
    116e:	6a 01                	push   $0x1
    1170:	e8 fb 03 00 00       	call   1570 <printf>
  *p = 69;
    1175:	c7 05 ff 2f 00 00 45 	movl   $0x45,0x2fff
    117c:	00 00 00 
    117f:	e9 62 ff ff ff       	jmp    10e6 <main+0xe6>
    printf(1, "[pid %d] test failed.\n", pid); 
    1184:	50                   	push   %eax
    1185:	53                   	push   %ebx
    1186:	68 1f 1a 00 00       	push   $0x1a1f
    118b:	6a 01                	push   $0x1
    118d:	e8 de 03 00 00       	call   1570 <printf>
    1192:	83 c4 10             	add    $0x10,%esp
    1195:	eb 9d                	jmp    1134 <main+0x134>
          printf(1, "[pid %d] test failed.\n", pid);
    1197:	52                   	push   %edx
    1198:	53                   	push   %ebx
    1199:	68 1f 1a 00 00       	push   $0x1a1f
    119e:	6a 01                	push   $0x1
    11a0:	e8 cb 03 00 00       	call   1570 <printf>
    11a5:	83 c4 10             	add    $0x10,%esp
    11a8:	eb bd                	jmp    1167 <main+0x167>
    11aa:	66 90                	xchg   %ax,%ax
    11ac:	66 90                	xchg   %ax,%ax
    11ae:	66 90                	xchg   %ax,%ax

000011b0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
    11b0:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    11b1:	31 c0                	xor    %eax,%eax
{
    11b3:	89 e5                	mov    %esp,%ebp
    11b5:	53                   	push   %ebx
    11b6:	8b 4d 08             	mov    0x8(%ebp),%ecx
    11b9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    11bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
    11c0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
    11c4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
    11c7:	83 c0 01             	add    $0x1,%eax
    11ca:	84 d2                	test   %dl,%dl
    11cc:	75 f2                	jne    11c0 <strcpy+0x10>
    ;
  return os;
}
    11ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    11d1:	89 c8                	mov    %ecx,%eax
    11d3:	c9                   	leave  
    11d4:	c3                   	ret    
    11d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    11dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000011e0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    11e0:	55                   	push   %ebp
    11e1:	89 e5                	mov    %esp,%ebp
    11e3:	53                   	push   %ebx
    11e4:	8b 55 08             	mov    0x8(%ebp),%edx
    11e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
    11ea:	0f b6 02             	movzbl (%edx),%eax
    11ed:	84 c0                	test   %al,%al
    11ef:	75 17                	jne    1208 <strcmp+0x28>
    11f1:	eb 3a                	jmp    122d <strcmp+0x4d>
    11f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    11f7:	90                   	nop
    11f8:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
    11fc:	83 c2 01             	add    $0x1,%edx
    11ff:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
    1202:	84 c0                	test   %al,%al
    1204:	74 1a                	je     1220 <strcmp+0x40>
    p++, q++;
    1206:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
    1208:	0f b6 19             	movzbl (%ecx),%ebx
    120b:	38 c3                	cmp    %al,%bl
    120d:	74 e9                	je     11f8 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
    120f:	29 d8                	sub    %ebx,%eax
}
    1211:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1214:	c9                   	leave  
    1215:	c3                   	ret    
    1216:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    121d:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
    1220:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
    1224:	31 c0                	xor    %eax,%eax
    1226:	29 d8                	sub    %ebx,%eax
}
    1228:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    122b:	c9                   	leave  
    122c:	c3                   	ret    
  return (uchar)*p - (uchar)*q;
    122d:	0f b6 19             	movzbl (%ecx),%ebx
    1230:	31 c0                	xor    %eax,%eax
    1232:	eb db                	jmp    120f <strcmp+0x2f>
    1234:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    123b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    123f:	90                   	nop

00001240 <strlen>:

uint
strlen(const char *s)
{
    1240:	55                   	push   %ebp
    1241:	89 e5                	mov    %esp,%ebp
    1243:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
    1246:	80 3a 00             	cmpb   $0x0,(%edx)
    1249:	74 15                	je     1260 <strlen+0x20>
    124b:	31 c0                	xor    %eax,%eax
    124d:	8d 76 00             	lea    0x0(%esi),%esi
    1250:	83 c0 01             	add    $0x1,%eax
    1253:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
    1257:	89 c1                	mov    %eax,%ecx
    1259:	75 f5                	jne    1250 <strlen+0x10>
    ;
  return n;
}
    125b:	89 c8                	mov    %ecx,%eax
    125d:	5d                   	pop    %ebp
    125e:	c3                   	ret    
    125f:	90                   	nop
  for(n = 0; s[n]; n++)
    1260:	31 c9                	xor    %ecx,%ecx
}
    1262:	5d                   	pop    %ebp
    1263:	89 c8                	mov    %ecx,%eax
    1265:	c3                   	ret    
    1266:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    126d:	8d 76 00             	lea    0x0(%esi),%esi

00001270 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1270:	55                   	push   %ebp
    1271:	89 e5                	mov    %esp,%ebp
    1273:	57                   	push   %edi
    1274:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    1277:	8b 4d 10             	mov    0x10(%ebp),%ecx
    127a:	8b 45 0c             	mov    0xc(%ebp),%eax
    127d:	89 d7                	mov    %edx,%edi
    127f:	fc                   	cld    
    1280:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    1282:	8b 7d fc             	mov    -0x4(%ebp),%edi
    1285:	89 d0                	mov    %edx,%eax
    1287:	c9                   	leave  
    1288:	c3                   	ret    
    1289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00001290 <strchr>:

char*
strchr(const char *s, char c)
{
    1290:	55                   	push   %ebp
    1291:	89 e5                	mov    %esp,%ebp
    1293:	8b 45 08             	mov    0x8(%ebp),%eax
    1296:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
    129a:	0f b6 10             	movzbl (%eax),%edx
    129d:	84 d2                	test   %dl,%dl
    129f:	75 12                	jne    12b3 <strchr+0x23>
    12a1:	eb 1d                	jmp    12c0 <strchr+0x30>
    12a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    12a7:	90                   	nop
    12a8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
    12ac:	83 c0 01             	add    $0x1,%eax
    12af:	84 d2                	test   %dl,%dl
    12b1:	74 0d                	je     12c0 <strchr+0x30>
    if(*s == c)
    12b3:	38 d1                	cmp    %dl,%cl
    12b5:	75 f1                	jne    12a8 <strchr+0x18>
      return (char*)s;
  return 0;
}
    12b7:	5d                   	pop    %ebp
    12b8:	c3                   	ret    
    12b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
    12c0:	31 c0                	xor    %eax,%eax
}
    12c2:	5d                   	pop    %ebp
    12c3:	c3                   	ret    
    12c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    12cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    12cf:	90                   	nop

000012d0 <gets>:

char*
gets(char *buf, int max)
{
    12d0:	55                   	push   %ebp
    12d1:	89 e5                	mov    %esp,%ebp
    12d3:	57                   	push   %edi
    12d4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    12d5:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
    12d8:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
    12d9:	31 db                	xor    %ebx,%ebx
{
    12db:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
    12de:	eb 27                	jmp    1307 <gets+0x37>
    cc = read(0, &c, 1);
    12e0:	83 ec 04             	sub    $0x4,%esp
    12e3:	6a 01                	push   $0x1
    12e5:	57                   	push   %edi
    12e6:	6a 00                	push   $0x0
    12e8:	e8 2e 01 00 00       	call   141b <read>
    if(cc < 1)
    12ed:	83 c4 10             	add    $0x10,%esp
    12f0:	85 c0                	test   %eax,%eax
    12f2:	7e 1d                	jle    1311 <gets+0x41>
      break;
    buf[i++] = c;
    12f4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    12f8:	8b 55 08             	mov    0x8(%ebp),%edx
    12fb:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
    12ff:	3c 0a                	cmp    $0xa,%al
    1301:	74 1d                	je     1320 <gets+0x50>
    1303:	3c 0d                	cmp    $0xd,%al
    1305:	74 19                	je     1320 <gets+0x50>
  for(i=0; i+1 < max; ){
    1307:	89 de                	mov    %ebx,%esi
    1309:	83 c3 01             	add    $0x1,%ebx
    130c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    130f:	7c cf                	jl     12e0 <gets+0x10>
      break;
  }
  buf[i] = '\0';
    1311:	8b 45 08             	mov    0x8(%ebp),%eax
    1314:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
    1318:	8d 65 f4             	lea    -0xc(%ebp),%esp
    131b:	5b                   	pop    %ebx
    131c:	5e                   	pop    %esi
    131d:	5f                   	pop    %edi
    131e:	5d                   	pop    %ebp
    131f:	c3                   	ret    
  buf[i] = '\0';
    1320:	8b 45 08             	mov    0x8(%ebp),%eax
    1323:	89 de                	mov    %ebx,%esi
    1325:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
    1329:	8d 65 f4             	lea    -0xc(%ebp),%esp
    132c:	5b                   	pop    %ebx
    132d:	5e                   	pop    %esi
    132e:	5f                   	pop    %edi
    132f:	5d                   	pop    %ebp
    1330:	c3                   	ret    
    1331:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1338:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    133f:	90                   	nop

00001340 <stat>:

int
stat(const char *n, struct stat *st)
{
    1340:	55                   	push   %ebp
    1341:	89 e5                	mov    %esp,%ebp
    1343:	56                   	push   %esi
    1344:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1345:	83 ec 08             	sub    $0x8,%esp
    1348:	6a 00                	push   $0x0
    134a:	ff 75 08             	push   0x8(%ebp)
    134d:	e8 f1 00 00 00       	call   1443 <open>
  if(fd < 0)
    1352:	83 c4 10             	add    $0x10,%esp
    1355:	85 c0                	test   %eax,%eax
    1357:	78 27                	js     1380 <stat+0x40>
    return -1;
  r = fstat(fd, st);
    1359:	83 ec 08             	sub    $0x8,%esp
    135c:	ff 75 0c             	push   0xc(%ebp)
    135f:	89 c3                	mov    %eax,%ebx
    1361:	50                   	push   %eax
    1362:	e8 f4 00 00 00       	call   145b <fstat>
  close(fd);
    1367:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
    136a:	89 c6                	mov    %eax,%esi
  close(fd);
    136c:	e8 ba 00 00 00       	call   142b <close>
  return r;
    1371:	83 c4 10             	add    $0x10,%esp
}
    1374:	8d 65 f8             	lea    -0x8(%ebp),%esp
    1377:	89 f0                	mov    %esi,%eax
    1379:	5b                   	pop    %ebx
    137a:	5e                   	pop    %esi
    137b:	5d                   	pop    %ebp
    137c:	c3                   	ret    
    137d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
    1380:	be ff ff ff ff       	mov    $0xffffffff,%esi
    1385:	eb ed                	jmp    1374 <stat+0x34>
    1387:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    138e:	66 90                	xchg   %ax,%ax

00001390 <atoi>:

int
atoi(const char *s)
{
    1390:	55                   	push   %ebp
    1391:	89 e5                	mov    %esp,%ebp
    1393:	53                   	push   %ebx
    1394:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1397:	0f be 02             	movsbl (%edx),%eax
    139a:	8d 48 d0             	lea    -0x30(%eax),%ecx
    139d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
    13a0:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
    13a5:	77 1e                	ja     13c5 <atoi+0x35>
    13a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    13ae:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
    13b0:	83 c2 01             	add    $0x1,%edx
    13b3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
    13b6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
    13ba:	0f be 02             	movsbl (%edx),%eax
    13bd:	8d 58 d0             	lea    -0x30(%eax),%ebx
    13c0:	80 fb 09             	cmp    $0x9,%bl
    13c3:	76 eb                	jbe    13b0 <atoi+0x20>
  return n;
}
    13c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    13c8:	89 c8                	mov    %ecx,%eax
    13ca:	c9                   	leave  
    13cb:	c3                   	ret    
    13cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000013d0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    13d0:	55                   	push   %ebp
    13d1:	89 e5                	mov    %esp,%ebp
    13d3:	57                   	push   %edi
    13d4:	8b 45 10             	mov    0x10(%ebp),%eax
    13d7:	8b 55 08             	mov    0x8(%ebp),%edx
    13da:	56                   	push   %esi
    13db:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    13de:	85 c0                	test   %eax,%eax
    13e0:	7e 13                	jle    13f5 <memmove+0x25>
    13e2:	01 d0                	add    %edx,%eax
  dst = vdst;
    13e4:	89 d7                	mov    %edx,%edi
    13e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    13ed:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
    13f0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
    13f1:	39 f8                	cmp    %edi,%eax
    13f3:	75 fb                	jne    13f0 <memmove+0x20>
  return vdst;
}
    13f5:	5e                   	pop    %esi
    13f6:	89 d0                	mov    %edx,%eax
    13f8:	5f                   	pop    %edi
    13f9:	5d                   	pop    %ebp
    13fa:	c3                   	ret    

000013fb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    13fb:	b8 01 00 00 00       	mov    $0x1,%eax
    1400:	cd 40                	int    $0x40
    1402:	c3                   	ret    

00001403 <exit>:
SYSCALL(exit)
    1403:	b8 02 00 00 00       	mov    $0x2,%eax
    1408:	cd 40                	int    $0x40
    140a:	c3                   	ret    

0000140b <wait>:
SYSCALL(wait)
    140b:	b8 03 00 00 00       	mov    $0x3,%eax
    1410:	cd 40                	int    $0x40
    1412:	c3                   	ret    

00001413 <pipe>:
SYSCALL(pipe)
    1413:	b8 04 00 00 00       	mov    $0x4,%eax
    1418:	cd 40                	int    $0x40
    141a:	c3                   	ret    

0000141b <read>:
SYSCALL(read)
    141b:	b8 05 00 00 00       	mov    $0x5,%eax
    1420:	cd 40                	int    $0x40
    1422:	c3                   	ret    

00001423 <write>:
SYSCALL(write)
    1423:	b8 10 00 00 00       	mov    $0x10,%eax
    1428:	cd 40                	int    $0x40
    142a:	c3                   	ret    

0000142b <close>:
SYSCALL(close)
    142b:	b8 15 00 00 00       	mov    $0x15,%eax
    1430:	cd 40                	int    $0x40
    1432:	c3                   	ret    

00001433 <kill>:
SYSCALL(kill)
    1433:	b8 06 00 00 00       	mov    $0x6,%eax
    1438:	cd 40                	int    $0x40
    143a:	c3                   	ret    

0000143b <exec>:
SYSCALL(exec)
    143b:	b8 07 00 00 00       	mov    $0x7,%eax
    1440:	cd 40                	int    $0x40
    1442:	c3                   	ret    

00001443 <open>:
SYSCALL(open)
    1443:	b8 0f 00 00 00       	mov    $0xf,%eax
    1448:	cd 40                	int    $0x40
    144a:	c3                   	ret    

0000144b <mknod>:
SYSCALL(mknod)
    144b:	b8 11 00 00 00       	mov    $0x11,%eax
    1450:	cd 40                	int    $0x40
    1452:	c3                   	ret    

00001453 <unlink>:
SYSCALL(unlink)
    1453:	b8 12 00 00 00       	mov    $0x12,%eax
    1458:	cd 40                	int    $0x40
    145a:	c3                   	ret    

0000145b <fstat>:
SYSCALL(fstat)
    145b:	b8 08 00 00 00       	mov    $0x8,%eax
    1460:	cd 40                	int    $0x40
    1462:	c3                   	ret    

00001463 <link>:
SYSCALL(link)
    1463:	b8 13 00 00 00       	mov    $0x13,%eax
    1468:	cd 40                	int    $0x40
    146a:	c3                   	ret    

0000146b <mkdir>:
SYSCALL(mkdir)
    146b:	b8 14 00 00 00       	mov    $0x14,%eax
    1470:	cd 40                	int    $0x40
    1472:	c3                   	ret    

00001473 <chdir>:
SYSCALL(chdir)
    1473:	b8 09 00 00 00       	mov    $0x9,%eax
    1478:	cd 40                	int    $0x40
    147a:	c3                   	ret    

0000147b <dup>:
SYSCALL(dup)
    147b:	b8 0a 00 00 00       	mov    $0xa,%eax
    1480:	cd 40                	int    $0x40
    1482:	c3                   	ret    

00001483 <getpid>:
SYSCALL(getpid)
    1483:	b8 0b 00 00 00       	mov    $0xb,%eax
    1488:	cd 40                	int    $0x40
    148a:	c3                   	ret    

0000148b <sbrk>:
SYSCALL(sbrk)
    148b:	b8 0c 00 00 00       	mov    $0xc,%eax
    1490:	cd 40                	int    $0x40
    1492:	c3                   	ret    

00001493 <sleep>:
SYSCALL(sleep)
    1493:	b8 0d 00 00 00       	mov    $0xd,%eax
    1498:	cd 40                	int    $0x40
    149a:	c3                   	ret    

0000149b <uptime>:
SYSCALL(uptime)
    149b:	b8 0e 00 00 00       	mov    $0xe,%eax
    14a0:	cd 40                	int    $0x40
    14a2:	c3                   	ret    

000014a3 <mprotect>:
SYSCALL(mprotect)
    14a3:	b8 16 00 00 00       	mov    $0x16,%eax
    14a8:	cd 40                	int    $0x40
    14aa:	c3                   	ret    

000014ab <munprotect>:
SYSCALL(munprotect)
    14ab:	b8 17 00 00 00       	mov    $0x17,%eax
    14b0:	cd 40                	int    $0x40
    14b2:	c3                   	ret    
    14b3:	66 90                	xchg   %ax,%ax
    14b5:	66 90                	xchg   %ax,%ax
    14b7:	66 90                	xchg   %ax,%ax
    14b9:	66 90                	xchg   %ax,%ax
    14bb:	66 90                	xchg   %ax,%ax
    14bd:	66 90                	xchg   %ax,%ax
    14bf:	90                   	nop

000014c0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    14c0:	55                   	push   %ebp
    14c1:	89 e5                	mov    %esp,%ebp
    14c3:	57                   	push   %edi
    14c4:	56                   	push   %esi
    14c5:	53                   	push   %ebx
    14c6:	83 ec 3c             	sub    $0x3c,%esp
    14c9:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
    14cc:	89 d1                	mov    %edx,%ecx
{
    14ce:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
    14d1:	85 d2                	test   %edx,%edx
    14d3:	0f 89 7f 00 00 00    	jns    1558 <printint+0x98>
    14d9:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
    14dd:	74 79                	je     1558 <printint+0x98>
    neg = 1;
    14df:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
    14e6:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
    14e8:	31 db                	xor    %ebx,%ebx
    14ea:	8d 75 d7             	lea    -0x29(%ebp),%esi
    14ed:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
    14f0:	89 c8                	mov    %ecx,%eax
    14f2:	31 d2                	xor    %edx,%edx
    14f4:	89 cf                	mov    %ecx,%edi
    14f6:	f7 75 c4             	divl   -0x3c(%ebp)
    14f9:	0f b6 92 cc 1a 00 00 	movzbl 0x1acc(%edx),%edx
    1500:	89 45 c0             	mov    %eax,-0x40(%ebp)
    1503:	89 d8                	mov    %ebx,%eax
    1505:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
    1508:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
    150b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
    150e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
    1511:	76 dd                	jbe    14f0 <printint+0x30>
  if(neg)
    1513:	8b 4d bc             	mov    -0x44(%ebp),%ecx
    1516:	85 c9                	test   %ecx,%ecx
    1518:	74 0c                	je     1526 <printint+0x66>
    buf[i++] = '-';
    151a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
    151f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
    1521:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
    1526:	8b 7d b8             	mov    -0x48(%ebp),%edi
    1529:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
    152d:	eb 07                	jmp    1536 <printint+0x76>
    152f:	90                   	nop
    putc(fd, buf[i]);
    1530:	0f b6 13             	movzbl (%ebx),%edx
    1533:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
    1536:	83 ec 04             	sub    $0x4,%esp
    1539:	88 55 d7             	mov    %dl,-0x29(%ebp)
    153c:	6a 01                	push   $0x1
    153e:	56                   	push   %esi
    153f:	57                   	push   %edi
    1540:	e8 de fe ff ff       	call   1423 <write>
  while(--i >= 0)
    1545:	83 c4 10             	add    $0x10,%esp
    1548:	39 de                	cmp    %ebx,%esi
    154a:	75 e4                	jne    1530 <printint+0x70>
}
    154c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    154f:	5b                   	pop    %ebx
    1550:	5e                   	pop    %esi
    1551:	5f                   	pop    %edi
    1552:	5d                   	pop    %ebp
    1553:	c3                   	ret    
    1554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
    1558:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
    155f:	eb 87                	jmp    14e8 <printint+0x28>
    1561:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1568:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    156f:	90                   	nop

00001570 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    1570:	55                   	push   %ebp
    1571:	89 e5                	mov    %esp,%ebp
    1573:	57                   	push   %edi
    1574:	56                   	push   %esi
    1575:	53                   	push   %ebx
    1576:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1579:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
    157c:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i = 0; fmt[i]; i++){
    157f:	0f b6 13             	movzbl (%ebx),%edx
    1582:	84 d2                	test   %dl,%dl
    1584:	74 6a                	je     15f0 <printf+0x80>
  ap = (uint*)(void*)&fmt + 1;
    1586:	8d 45 10             	lea    0x10(%ebp),%eax
    1589:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
    158c:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
    158f:	31 c9                	xor    %ecx,%ecx
  ap = (uint*)(void*)&fmt + 1;
    1591:	89 45 d0             	mov    %eax,-0x30(%ebp)
    1594:	eb 36                	jmp    15cc <printf+0x5c>
    1596:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    159d:	8d 76 00             	lea    0x0(%esi),%esi
    15a0:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
    15a3:	b9 25 00 00 00       	mov    $0x25,%ecx
      if(c == '%'){
    15a8:	83 f8 25             	cmp    $0x25,%eax
    15ab:	74 15                	je     15c2 <printf+0x52>
  write(fd, &c, 1);
    15ad:	83 ec 04             	sub    $0x4,%esp
    15b0:	88 55 e7             	mov    %dl,-0x19(%ebp)
    15b3:	6a 01                	push   $0x1
    15b5:	57                   	push   %edi
    15b6:	56                   	push   %esi
    15b7:	e8 67 fe ff ff       	call   1423 <write>
    15bc:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      } else {
        putc(fd, c);
    15bf:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
    15c2:	0f b6 13             	movzbl (%ebx),%edx
    15c5:	83 c3 01             	add    $0x1,%ebx
    15c8:	84 d2                	test   %dl,%dl
    15ca:	74 24                	je     15f0 <printf+0x80>
    c = fmt[i] & 0xff;
    15cc:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
    15cf:	85 c9                	test   %ecx,%ecx
    15d1:	74 cd                	je     15a0 <printf+0x30>
      }
    } else if(state == '%'){
    15d3:	83 f9 25             	cmp    $0x25,%ecx
    15d6:	75 ea                	jne    15c2 <printf+0x52>
      if(c == 'd'){
    15d8:	83 f8 25             	cmp    $0x25,%eax
    15db:	0f 84 07 01 00 00    	je     16e8 <printf+0x178>
    15e1:	83 e8 63             	sub    $0x63,%eax
    15e4:	83 f8 15             	cmp    $0x15,%eax
    15e7:	77 17                	ja     1600 <printf+0x90>
    15e9:	ff 24 85 74 1a 00 00 	jmp    *0x1a74(,%eax,4)
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    15f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    15f3:	5b                   	pop    %ebx
    15f4:	5e                   	pop    %esi
    15f5:	5f                   	pop    %edi
    15f6:	5d                   	pop    %ebp
    15f7:	c3                   	ret    
    15f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    15ff:	90                   	nop
  write(fd, &c, 1);
    1600:	83 ec 04             	sub    $0x4,%esp
    1603:	88 55 d4             	mov    %dl,-0x2c(%ebp)
    1606:	6a 01                	push   $0x1
    1608:	57                   	push   %edi
    1609:	56                   	push   %esi
    160a:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
    160e:	e8 10 fe ff ff       	call   1423 <write>
        putc(fd, c);
    1613:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
  write(fd, &c, 1);
    1617:	83 c4 0c             	add    $0xc,%esp
    161a:	88 55 e7             	mov    %dl,-0x19(%ebp)
    161d:	6a 01                	push   $0x1
    161f:	57                   	push   %edi
    1620:	56                   	push   %esi
    1621:	e8 fd fd ff ff       	call   1423 <write>
        putc(fd, c);
    1626:	83 c4 10             	add    $0x10,%esp
      state = 0;
    1629:	31 c9                	xor    %ecx,%ecx
    162b:	eb 95                	jmp    15c2 <printf+0x52>
    162d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
    1630:	83 ec 0c             	sub    $0xc,%esp
    1633:	b9 10 00 00 00       	mov    $0x10,%ecx
    1638:	6a 00                	push   $0x0
    163a:	8b 45 d0             	mov    -0x30(%ebp),%eax
    163d:	8b 10                	mov    (%eax),%edx
    163f:	89 f0                	mov    %esi,%eax
    1641:	e8 7a fe ff ff       	call   14c0 <printint>
        ap++;
    1646:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
    164a:	83 c4 10             	add    $0x10,%esp
      state = 0;
    164d:	31 c9                	xor    %ecx,%ecx
    164f:	e9 6e ff ff ff       	jmp    15c2 <printf+0x52>
    1654:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
    1658:	8b 45 d0             	mov    -0x30(%ebp),%eax
    165b:	8b 10                	mov    (%eax),%edx
        ap++;
    165d:	83 c0 04             	add    $0x4,%eax
    1660:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
    1663:	85 d2                	test   %edx,%edx
    1665:	0f 84 8d 00 00 00    	je     16f8 <printf+0x188>
        while(*s != 0){
    166b:	0f b6 02             	movzbl (%edx),%eax
      state = 0;
    166e:	31 c9                	xor    %ecx,%ecx
        while(*s != 0){
    1670:	84 c0                	test   %al,%al
    1672:	0f 84 4a ff ff ff    	je     15c2 <printf+0x52>
    1678:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
    167b:	89 d3                	mov    %edx,%ebx
    167d:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
    1680:	83 ec 04             	sub    $0x4,%esp
          s++;
    1683:	83 c3 01             	add    $0x1,%ebx
    1686:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    1689:	6a 01                	push   $0x1
    168b:	57                   	push   %edi
    168c:	56                   	push   %esi
    168d:	e8 91 fd ff ff       	call   1423 <write>
        while(*s != 0){
    1692:	0f b6 03             	movzbl (%ebx),%eax
    1695:	83 c4 10             	add    $0x10,%esp
    1698:	84 c0                	test   %al,%al
    169a:	75 e4                	jne    1680 <printf+0x110>
      state = 0;
    169c:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
    169f:	31 c9                	xor    %ecx,%ecx
    16a1:	e9 1c ff ff ff       	jmp    15c2 <printf+0x52>
    16a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    16ad:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
    16b0:	83 ec 0c             	sub    $0xc,%esp
    16b3:	b9 0a 00 00 00       	mov    $0xa,%ecx
    16b8:	6a 01                	push   $0x1
    16ba:	e9 7b ff ff ff       	jmp    163a <printf+0xca>
    16bf:	90                   	nop
        putc(fd, *ap);
    16c0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  write(fd, &c, 1);
    16c3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
    16c6:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
    16c8:	6a 01                	push   $0x1
    16ca:	57                   	push   %edi
    16cb:	56                   	push   %esi
        putc(fd, *ap);
    16cc:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    16cf:	e8 4f fd ff ff       	call   1423 <write>
        ap++;
    16d4:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
    16d8:	83 c4 10             	add    $0x10,%esp
      state = 0;
    16db:	31 c9                	xor    %ecx,%ecx
    16dd:	e9 e0 fe ff ff       	jmp    15c2 <printf+0x52>
    16e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        putc(fd, c);
    16e8:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
    16eb:	83 ec 04             	sub    $0x4,%esp
    16ee:	e9 2a ff ff ff       	jmp    161d <printf+0xad>
    16f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    16f7:	90                   	nop
          s = "(null)";
    16f8:	ba 6a 1a 00 00       	mov    $0x1a6a,%edx
        while(*s != 0){
    16fd:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
    1700:	b8 28 00 00 00       	mov    $0x28,%eax
    1705:	89 d3                	mov    %edx,%ebx
    1707:	e9 74 ff ff ff       	jmp    1680 <printf+0x110>
    170c:	66 90                	xchg   %ax,%ax
    170e:	66 90                	xchg   %ax,%ax

00001710 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1710:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1711:	a1 00 50 00 00       	mov    0x5000,%eax
{
    1716:	89 e5                	mov    %esp,%ebp
    1718:	57                   	push   %edi
    1719:	56                   	push   %esi
    171a:	53                   	push   %ebx
    171b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
    171e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1721:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1728:	89 c2                	mov    %eax,%edx
    172a:	8b 00                	mov    (%eax),%eax
    172c:	39 ca                	cmp    %ecx,%edx
    172e:	73 30                	jae    1760 <free+0x50>
    1730:	39 c1                	cmp    %eax,%ecx
    1732:	72 04                	jb     1738 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1734:	39 c2                	cmp    %eax,%edx
    1736:	72 f0                	jb     1728 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1738:	8b 73 fc             	mov    -0x4(%ebx),%esi
    173b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    173e:	39 f8                	cmp    %edi,%eax
    1740:	74 30                	je     1772 <free+0x62>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
    1742:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    1745:	8b 42 04             	mov    0x4(%edx),%eax
    1748:	8d 34 c2             	lea    (%edx,%eax,8),%esi
    174b:	39 f1                	cmp    %esi,%ecx
    174d:	74 3a                	je     1789 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
    174f:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
    1751:	5b                   	pop    %ebx
  freep = p;
    1752:	89 15 00 50 00 00    	mov    %edx,0x5000
}
    1758:	5e                   	pop    %esi
    1759:	5f                   	pop    %edi
    175a:	5d                   	pop    %ebp
    175b:	c3                   	ret    
    175c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1760:	39 c2                	cmp    %eax,%edx
    1762:	72 c4                	jb     1728 <free+0x18>
    1764:	39 c1                	cmp    %eax,%ecx
    1766:	73 c0                	jae    1728 <free+0x18>
  if(bp + bp->s.size == p->s.ptr){
    1768:	8b 73 fc             	mov    -0x4(%ebx),%esi
    176b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    176e:	39 f8                	cmp    %edi,%eax
    1770:	75 d0                	jne    1742 <free+0x32>
    bp->s.size += p->s.ptr->s.size;
    1772:	03 70 04             	add    0x4(%eax),%esi
    1775:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    1778:	8b 02                	mov    (%edx),%eax
    177a:	8b 00                	mov    (%eax),%eax
    177c:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
    177f:	8b 42 04             	mov    0x4(%edx),%eax
    1782:	8d 34 c2             	lea    (%edx,%eax,8),%esi
    1785:	39 f1                	cmp    %esi,%ecx
    1787:	75 c6                	jne    174f <free+0x3f>
    p->s.size += bp->s.size;
    1789:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
    178c:	89 15 00 50 00 00    	mov    %edx,0x5000
    p->s.size += bp->s.size;
    1792:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
    1795:	8b 4b f8             	mov    -0x8(%ebx),%ecx
    1798:	89 0a                	mov    %ecx,(%edx)
}
    179a:	5b                   	pop    %ebx
    179b:	5e                   	pop    %esi
    179c:	5f                   	pop    %edi
    179d:	5d                   	pop    %ebp
    179e:	c3                   	ret    
    179f:	90                   	nop

000017a0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    17a0:	55                   	push   %ebp
    17a1:	89 e5                	mov    %esp,%ebp
    17a3:	57                   	push   %edi
    17a4:	56                   	push   %esi
    17a5:	53                   	push   %ebx
    17a6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    17a9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
    17ac:	8b 3d 00 50 00 00    	mov    0x5000,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    17b2:	8d 70 07             	lea    0x7(%eax),%esi
    17b5:	c1 ee 03             	shr    $0x3,%esi
    17b8:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
    17bb:	85 ff                	test   %edi,%edi
    17bd:	0f 84 9d 00 00 00    	je     1860 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    17c3:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
    17c5:	8b 4a 04             	mov    0x4(%edx),%ecx
    17c8:	39 f1                	cmp    %esi,%ecx
    17ca:	73 6a                	jae    1836 <malloc+0x96>
    17cc:	bb 00 10 00 00       	mov    $0x1000,%ebx
    17d1:	39 de                	cmp    %ebx,%esi
    17d3:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
    17d6:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
    17dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    17e0:	eb 17                	jmp    17f9 <malloc+0x59>
    17e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    17e8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    17ea:	8b 48 04             	mov    0x4(%eax),%ecx
    17ed:	39 f1                	cmp    %esi,%ecx
    17ef:	73 4f                	jae    1840 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    17f1:	8b 3d 00 50 00 00    	mov    0x5000,%edi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    17f7:	89 c2                	mov    %eax,%edx
    if(p == freep)
    17f9:	39 fa                	cmp    %edi,%edx
    17fb:	75 eb                	jne    17e8 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
    17fd:	83 ec 0c             	sub    $0xc,%esp
    1800:	ff 75 e4             	push   -0x1c(%ebp)
    1803:	e8 83 fc ff ff       	call   148b <sbrk>
  if(p == (char*)-1)
    1808:	83 c4 10             	add    $0x10,%esp
    180b:	83 f8 ff             	cmp    $0xffffffff,%eax
    180e:	74 1c                	je     182c <malloc+0x8c>
  hp->s.size = nu;
    1810:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
    1813:	83 ec 0c             	sub    $0xc,%esp
    1816:	83 c0 08             	add    $0x8,%eax
    1819:	50                   	push   %eax
    181a:	e8 f1 fe ff ff       	call   1710 <free>
  return freep;
    181f:	8b 15 00 50 00 00    	mov    0x5000,%edx
      if((p = morecore(nunits)) == 0)
    1825:	83 c4 10             	add    $0x10,%esp
    1828:	85 d2                	test   %edx,%edx
    182a:	75 bc                	jne    17e8 <malloc+0x48>
        return 0;
  }
}
    182c:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
    182f:	31 c0                	xor    %eax,%eax
}
    1831:	5b                   	pop    %ebx
    1832:	5e                   	pop    %esi
    1833:	5f                   	pop    %edi
    1834:	5d                   	pop    %ebp
    1835:	c3                   	ret    
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1836:	89 d0                	mov    %edx,%eax
    if(p->s.size >= nunits){
    1838:	89 fa                	mov    %edi,%edx
    183a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
    1840:	39 ce                	cmp    %ecx,%esi
    1842:	74 4c                	je     1890 <malloc+0xf0>
        p->s.size -= nunits;
    1844:	29 f1                	sub    %esi,%ecx
    1846:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
    1849:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
    184c:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
    184f:	89 15 00 50 00 00    	mov    %edx,0x5000
}
    1855:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
    1858:	83 c0 08             	add    $0x8,%eax
}
    185b:	5b                   	pop    %ebx
    185c:	5e                   	pop    %esi
    185d:	5f                   	pop    %edi
    185e:	5d                   	pop    %ebp
    185f:	c3                   	ret    
    base.s.ptr = freep = prevp = &base;
    1860:	c7 05 00 50 00 00 04 	movl   $0x5004,0x5000
    1867:	50 00 00 
    base.s.size = 0;
    186a:	bf 04 50 00 00       	mov    $0x5004,%edi
    base.s.ptr = freep = prevp = &base;
    186f:	c7 05 04 50 00 00 04 	movl   $0x5004,0x5004
    1876:	50 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1879:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
    187b:	c7 05 08 50 00 00 00 	movl   $0x0,0x5008
    1882:	00 00 00 
    if(p->s.size >= nunits){
    1885:	e9 42 ff ff ff       	jmp    17cc <malloc+0x2c>
    188a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
    1890:	8b 08                	mov    (%eax),%ecx
    1892:	89 0a                	mov    %ecx,(%edx)
    1894:	eb b9                	jmp    184f <malloc+0xaf>
