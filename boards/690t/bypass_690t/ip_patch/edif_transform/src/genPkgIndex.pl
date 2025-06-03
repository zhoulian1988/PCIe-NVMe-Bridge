#! /usr/bin/perl -w
use strict;
open OUT,">pkgIndex.tcl" or die "cannot create pkgIndex.tcl";
my $prefix = "jfm";
my $version = "0.1";
print OUT "proc getDir {} {\n";
print OUT "\tset fileName [info script]\n";
print OUT "\tset dir [file dirname \$fileName]\n";
print OUT "\treturn \$dir\n";
print OUT "}\n";
print OUT "set jfmScriptDir [getDir]\n\n";
my @packages0 = qw(JtagDebugTool Kit);
my @packages1 = qw(Design Device);

for my$pkg(@packages0){
	&genSourceFile0($pkg);
}
for my$pkg(@packages1){
	&genSourceFile1($pkg);
}


sub genSourceFile0{
	my $pkg = shift;
	my $name = $pkg;
	$name =~ s/\//::/g;
	print OUT "package ifneeded $prefix$name $version {\n";
	my @files = glob("$pkg/*.tcl");
	for(@files){
		my @path = split(/\//,$_);
		print OUT "\tsource [file join \$jfmScriptDir @path]\n";
	}
	print OUT "}\n";
}

sub genSourceFile1{
	my $dir = shift;
	my @subpackages = ();
	for(glob("$dir/*")){
		push @subpackages,$_ if(-d $_);
	}

	for my$pkg(@subpackages){
		&genSourceFile0($pkg);
	}
}
