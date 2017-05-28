#!/usr/bin/perl
use DateTime;
use POSIX qw(strftime);
no warnings 'uninitialized';

my $y = strftime "%Y", localtime;
my $m = strftime "%m", localtime;
my $d = strftime "%d", localtime;
my $today = DateTime->new(year => $y, month => $m, day => $d);

open(MAINFILE,'frequency_database');
@lines = <MAINFILE>;
close(MAINFILE);
$content = join('',@lines);
open(ATTRFILE, 'nice_classifier_attributes.csv');
@attributes = <ATTRFILE>;
close(ATTRFILE);
$attr = join('',@attributes);
#print "$content";
open(MYFILE,'daily_database');
while(<MYFILE>) {
	chomp;
	@arr = split /\t/, $_;
	#print "$_\n";
	#print "$arr[0]\n";
	#$content =~ s/($arr[0]\t)(\d+)/$arr[0]."\t".($arr[1]*3+$2)/e;

	$content =~ s/($arr[0]\t)(\d+)\t(\d+)-(\d+)-(\d+)/$arr[0]."\t!!!\t".($arr[1]*3+$2)/e;
	#print "day: $3, month: $4, year: $5\n";
	#print "old freq: $2\n";
	$temp = length $1;
	#print $temp;
	if( $temp > 0 ) {
		#print "old process\n";
		$olddate = DateTime->new(year => $5, month => $4, day => $3);
		$days = $today->delta_days($olddate)->delta_days();
		$content =~ s/!!!\t(\d+)/"\t!!!\t".(-$days+$1)."\t$d-$m-$y"/e;
		#print "before sub days:$1 days:$days\n";
		$new_fq = -$days+$1;
		#print "after sub days:$new_fq\n";
		if( $new_fq > 50 ) {
			#print "greater than 50";
			$new_fq = 50;	
		} elsif( $new_fq < 0 ) {
			$new_fq = 0;
		} 
		$content =~ s/\t!!!\t(-?\d+)/($new_fq)/e;
		$attr =~ s/($arr[0])(.*,)(\d+)(,[ACNF])/$1.$2.$new_fq.$4/e;

	}
	else {
		#print "new process\n";
		$content = $content."\n$arr[0]\t".3*$arr[1]."\t$d-$m-$y";
	}
}
close(MYFILE);
#print "$content";
open(MAINFILE,'>frequency_database');
print MAINFILE $content;
close(MAINFILE);
open(ATTRFILE,'>nice_classifier_attributes.csv');
print ATTRFILE $attr;
close(ATTRFILE);
