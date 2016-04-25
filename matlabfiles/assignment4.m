P=[0.8 0.1 0.1
0 0.2 0.8
0.7 0.3 0];
[Q,D] = eig(P);
Dn=round(D^10);
Pn=Q*Dn*Q^-1;
L=P-Q*D*Q^-1;


