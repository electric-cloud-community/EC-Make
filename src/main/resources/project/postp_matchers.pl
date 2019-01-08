use ElectricCommander;

push(@::gMatchers,

    #Makefile error:
    #makefile:3: *** missing separator.  Stop.
    
  {
   id =>        "makefileError",
   pattern =>          q{(.+):(\d+): (\**)(.+) Stop.},
   action =>           q{
    
              my $description = ((defined $::gProperties{"summary"}) ? 
                    $::gProperties{"summary"} : '');
                    
              $description .= "An error occurred on  $1, line $2:$4";
                              
              setProperty("summary", $description . "\n");    
    
   },
  },
     
    # Makeerror:
    # make: *** No rule to make target `x'.  Stop.
    # make: *** No rule to make target `@echo', needed by `aa'.  Stop.

  {
   id =>        "makeError",
   pattern =>          q{make(\[\d*\])?: \*\*\* No rule to make target(.+)Stop\.},
   action =>           q{
    
              my $description = ((defined $::gProperties{"summary"}) ? 
                    $::gProperties{"summary"} : '');
                    
              $description .= "An error occurred: $2";
                              
              setProperty("summary", $description . "\n");    
    
   },
  },
);