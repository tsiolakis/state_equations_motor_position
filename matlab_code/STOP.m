delete(instrfind({'Port'},{'COM5'}));

a=arduino('COM5');

analogWrite(a,9,0);   
analogWrite(a,6,0);