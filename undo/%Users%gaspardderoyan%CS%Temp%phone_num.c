Vim�UnDo� �(�>VR��q��
W�KJ�TD��{���,�      "    printf("Number: %s\n", phnum);             8       8   8   8    gkl    _�                             ����                                                                                                                                                                                                                                                                                                                                                             gkj�     �                   �               5��                                          �       5�_�                            ����                                                                                                                                                                                                                                                                                                                                                  V        gkj�     �                 #include <stdint.h>       Cchar *create_phone_number(char phnum[15], const uint8_t digits[10])   {     int i;         i = 0;     while (i < 10)     {       *phnum = '0' + digits[i];       i++;       phnum++;     }     *phnum = '\0';     return phnum;   }5��                         [                     �                         g                     �                         r                     �                         �                     �    	                     �                     �    
                     �                     �                         �                     �                         �                     �                         �                     �                         �                     5�_�                            ����                                                                                                                                                                                                                                                                                                                                                  V        gkj�     �                  �               5��                          �                      �                          �                      �                          �                      5�_�                           ����                                                                                                                                                                                                                                                                                                                                                  V        gkj�     �                 int main5��                                              5�_�                       
    ����                                                                                                                                                                                                                                                                                                                                                  V        gkj�     �                 
int main()5��       
                                       5�_�                            ����                                                                                                                                                                                                                                                                                                                                                  V        gkj�     �                  5��                                               5�_�                           ����                                                                                                                                                                                                                                                                                                                                                  V        gkj�     �               {�                }�                 {}5��                                              �                                              �                       	                 	       5�_�      	                 	    ����                                                                                                                                                                                                                                                                                                                                                  V        gkj�     �               	    phnum5��       	                                       5�_�      
           	      
    ����                                                                                                                                                                                                                                                                                                                                                  V        gkj�     �                   phnum[]5��       
                                       �                                              �                                              5�_�   	              
          ����                                                                                                                                                                                                                                                                                                                                                  V        gkj�     �                   phnum[15];5��                         
                     �                                            5�_�   
                        ����                                                                                                                                                                                                                                                                                                                                                  V        gkj�     �             5��                                               �                                               5�_�                           ����                                                                                                                                                                                                                                                                                                                                                  V        gkj�     �                   �             5��                                               �                         !                     �                        )                    5�_�                           ����                                                                                                                                                                                                                                                                                                                                                  V        gkj�     �                   int     uint8_t5��                         0                     5�_�                           ����                                                                                                                                                                                                                                                                                                                                                  V        gkj�     �                   int     uint8_t[]5��                         1                     �                         4                     5�_�                           ����                                                                                                                                                                                                                                                                                                                                                  V        gkj�     �                   int     uint8_t[10] = 5��                         7                     5�_�                           ����                                                                                                                                                                                                                                                                                                                                                  V        gkj�     �                   int     uint8_t[10] = {}�             5��                         8                     �                     
   8             
       �       &                  C                     5�_�                           ����                                                                                                                                                                                                                                                                                                                                                  V        gkj�     �               '    int     uint8_t[10] = {0667048555};5��                         9                     5�_�                           ����                                                                                                                                                                                                                                                                                                                                                  V        gkk     �               )    int     uint8_t[10] = {0, 667048555};5��                         <                     5�_�                       "    ����                                                                                                                                                                                                                                                                                                                                                  V        gkk     �               +    int     uint8_t[10] = {0, 6, 67048555};5��       "                  ?                     5�_�                       %    ����                                                                                                                                                                                                                                                                                                                                                  V        gkk     �               -    int     uint8_t[10] = {0, 6, 6, 7048555};5��       %                  B                     5�_�                       (    ����                                                                                                                                                                                                                                                                                                                                                  V        gkk     �               /    int     uint8_t[10] = {0, 6, 6, 7, 048555};5��       (                  E                     5�_�                       +    ����                                                                                                                                                                                                                                                                                                                                                  V        gkk	     �               1    int     uint8_t[10] = {0, 6, 6, 7, 0, 48555};5��       +                  H                     5�_�                       .    ����                                                                                                                                                                                                                                                                                                                                                  V        gkk
     �               3    int     uint8_t[10] = {0, 6, 6, 7, 0, 4, 8555};5��       .                  K                     5�_�                       1    ����                                                                                                                                                                                                                                                                                                                                                  V        gkk
     �               5    int     uint8_t[10] = {0, 6, 6, 7, 0, 4, 8, 555};5��       1                  N                     5�_�                       4    ����                                                                                                                                                                                                                                                                                                                                                  V        gkk     �               7    int     uint8_t[10] = {0, 6, 6, 7, 0, 4, 8, 5, 55};5��       4                  Q                     5�_�                      7    ����                                                                                                                                                                                                                                                                                                                                                  V        gkk     �                   �             5��                          W                     �                          W                     �                         W                     �                          X                     5�_�                           ����                                                                                                                                                                                                                                                                                                                                                  V        gkk0     �                   �             5��                          f                      �                         j                      5�_�                           ����                                                                                                                                                                                                                                                                                                                                                  V        gkk6     �               
    int i;5��                        b                     5�_�                       	    ����                                                                                                                                                                                                                                                                                                                                                  V        gkk9     �      
             �      
       5��                          �                      �                         �                      5�_�                            ����                                                                                                                                                                                                                                                                                                                                                  V        gkk@     �                   return phnum;5��                                            5�_�      !                       ����                                                                                                                                                                                                                                                                                                                                                  V        gkkL     �                5��                          }                     �                     7   �             7       5�_�       "           !          ����                                                                                                                                                                                                                                                                                                                               "                 v       gkk[     �               ;    create_phone_number(char *phnum, const uint8_t *digits)5��                        �                    �                        �                    �                        �                    5�_�   !   #           "          ����                                                                                                                                                                                                                                                                                                                               "                 v       gkkc     �               5    create_phone_number(phnum, const uint8_t *digits)5��                         �                     �                         �                     5�_�   "   %           #          ����                                                                                                                                                                                                                                                                                                                                         3       v   3    gkk{     �               5    create_phone_number(phnum, const uint8_t *digits)5��                         �                     5�_�   #   &   $       %          ����                                                                                                                                                                                                                                                                                                                                         3       v   3    gkk�     �               9    int     uint8_t[10] = {0, 6, 6, 7, 0, 4, 8, 5, 5, 5};5��                         F                     5�_�   %   '           &          ����                                                                                                                                                                                                                                                                                                                                                v       gkk�     �               6         uint8_t[10] = {0, 6, 6, 7, 0, 4, 8, 5, 5, 5};5��                         F                     5�_�   &   (           '          ����                                                                                                                                                                                                                                                                                                                                                v       gkk�     �               1    uint8_t[10] = {0, 6, 6, 7, 0, 4, 8, 5, 5, 5};5��                         M                     5�_�   '   )           (          ����                                                                                                                                                                                                                                                                                                                                                v       gkk�    �                    create_phone_number(phnum, )5��                         �                     �       $                  �                     5�_�   (   *           )      $    ����                                                                                                                                                                                                                                                                                                                                                v       gkk�     �                   �             5��                          �                     �                         �                     5�_�   )   +           *      
    ����                                                                                                                                                                                                                                                                                                                                                v       gkk�     �               
    printf5��       
                  �                     5�_�   *   ,           +          ����                                                                                                                                                                                                                                                                                                                                                v       gkk�     �                   printf()5��                         �                     5�_�   +   -           ,          ����                                                                                                                                                                                                                                                                                                                                                v       gkk�     �                   printf("")5��                         �                     �                         �                     �                        �                    5�_�   ,   .           -      !    ����                                                                                                                                                                                                                                                                                                                                                v       gkk�     �               !    printf("Number: %s\n", phnum)5��       !                  �                     5�_�   -   /           .      	    ����                                                                                                                                                                                                                                                                                                                                                v       gkk�    �                �             5��                                               �                                               �                                             5�_�   .   0           /          ����                                                                                                                                                                                                                                                                                                                                                v       gkk�     �             �             5��                          U                     5�_�   /   1           0          ����                                                                                                                                                                                                                                                                                                                                                v       gkk�     �                   char    phnum[15];5��                         f                     5�_�   0   2           1          ����                                                                                                                                                                                                                                                                                                                                                v       gkk�     �               %    create_phone_number(phnum, nums);5��                         �                     �                        �                    5�_�   1   3           2          ����                                                                                                                                                                                                                                                                                                                                                v       gkk�     �                   char    phnum2[15];5��                         g                     5�_�   2   4           3          ����                                                                                                                                                                                                                                                                                                                                                v       gkk�     �                   char    phnum215];5��                         g                     5�_�   3   5           4          ����                                                                                                                                                                                                                                                                                                                                                v       gkk�     �                   char    phnum25];5��                         g                     5�_�   4   6           5          ����                                                                                                                                                                                                                                                                                                                                                v       gkk�     �                   char    phnum2];5��                         g                     5�_�   5   7           6          ����                                                                                                                                                                                                                                                                                                                                                v       gkk�    �                   char    phnum2;5��                         a                     5�_�   6   8           7          ����                                                                                                                                                                                                                                                                                                                                                v       gkl     �             �             5��                          �              #       5�_�   7               8           ����                                                                                                                                                                                                                                                                                                                                                v       gkl    �               "    printf("Number: %s\n", phnum);5��                                               5�_�   #           %   $           ����                                                                                                                                                                                                                                                                                                                                         3       v   3    gkk�     �               >    inumbert     uint8_t[10] = {0, 6, 6, 7, 0, 4, 8, 5, 5, 5};5��                        G                    5�_�                       7    ����                                                                                                                                                                                                                                                                                                                                                  V        gkk     �               ;    int     uint8_t[10] = {0, 6, 6, 7, 0, 4, 8, 5, 5, 5, };5��       7                  T                     5��