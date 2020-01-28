function P = randomRoom(path,numRooms,minx,miny,maxx,maxy)
% Generates random coordinates for a rectangular room
% configuration: 
% x1 x2 y1 y2
% x1 y1 (startpoint) 
% x2 y2 (endpoint)

rng(0,'twister');

x = (maxx-minx).*rand(numRooms,1) + minx; % uniformly distributed
y = (maxy-miny).*rand(numRooms,1) + miny;

numDigits = length(num2str(numRooms));
precision = sprintf('%%0%dd',numDigits)

for i=1:numRooms
    P(1,:)=[0 x(i) 0 0];
    P(2,:)=[x(i) x(i) 0 y(i)];
    P(3,:)=[x(i) 0 y(i) y(i)];
    P(4,:)=[0 0 y(i) 0];
    
    roomNumStr = num2str(i,precision);
    filename = sprintf('%s/room_%s',path,roomNumStr);
    save(filename,'P')
end
end
