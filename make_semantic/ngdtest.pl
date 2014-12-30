#!/usr/bin/perl
use Math::Combinatorics;


open(N1,">totalnounpairs.csv");
open(N,"totalnountestandtrain.txt");
@noun="";#noun配列
@ngd="";#ngd配列
while(<N>){#unigramに対して
    
   @noun=(@noun,$_);

}
 @noun = map { $_ =~ s/\n$//; $_ } @noun;
#@noun=qw/@noun/;
@combi= map { join "," , @$_ }  combine(2, @noun);
#@noun=qw/@noun/;
#print "@noun";
#@combi=combine(2,@noun);
foreach(@combi)
{
print N1 "$_\n";


}
close(N);
close(N1);rr
