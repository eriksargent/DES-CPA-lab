function [weight] = HD(R1, R2, ind)
R1 = [R1(ind(1)) R1(ind(2)) R1(ind(3)) R1(ind(4))];
R2 = [R2(ind(1)) R2(ind(2)) R2(ind(3)) R2(ind(4))];
weight = sum(bitxor(R1, R2));
