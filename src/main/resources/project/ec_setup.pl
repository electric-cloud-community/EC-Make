my %runMake = (
    label       => "Make - Run Build",
    procedure   => "runMake",
    description => "Run make against a specific makefile.",
    category    => "Build"
);

$batch->deleteProperty("/server/ec_customEditors/pickerStep/EC-Make - runMake");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/Make - Run Build");

@::createStepPickerSteps = (\%runMake);
