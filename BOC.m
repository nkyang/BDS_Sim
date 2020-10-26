function bcode = BOC(code,m,n)
tmp = kron(ones(m/n,1),[1;-1]);
bcode = kron(code,tmp);
end