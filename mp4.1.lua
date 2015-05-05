function getFile(file_name)
  local f = assert(io.open(file_name, 'r'))

  a={}
  value={}
  q={}
  for i=-1,6 do
  	a[i]={}
    value[i]={}
    q[i]={}
  	for j=-1,6 do
      a[i][j]=2
      value[i][j]=2
      q[i][j]={}
      for k=1,4 do
      	q[i][j][k]=0
      end	
    end
  end    
  policy={}
  for i=0,5 do
  	policy[i]={}
    for j=0,5 do
      a[i][j]=f:read("*number")
      policy[i][j]=" wall"
      if a[i][j]~=2 then
        value[i][j]=a[i][j]
      else
        value[i][j]=0 
      end
    end
  end    
  
  
  f:close()
end

function get(ttt)
   if ttt==2 then
   	 return 0
   else
   	 if ttt==0 then
   	 	return -0.04
   	 else
   	 	return ttt
     end
   end	 
end

function bell()
  local tempval={}
  for i=0,5 do
  	tempval[i]={}
  	for j=0,5 do
      if a[i][j]~=2 then
      	up=0.8*get(value[i][j-1])+0.1*get(value[i-1][j])+0.1*get(value[i+1][j])
      	down=0.8*get(value[i][j+1])+0.1*get(value[i-1][j])+0.1*get(value[i+1][j])
        left=0.8*get(value[i-1][j])+0.1*get(value[i][j-1])+0.1*get(value[i+1][j+1])
        right=0.8*get(value[i+1][j])+0.1*get(value[i][j-1])+0.1*get(value[i+1][j+1])

        local t= {up,down,left,right} 
        local maxOfT = math.max(unpack(t))
        local p="     "
        if maxOfT==up then
           p="   up"
        end   
        if maxOfT==down then
           p=" down"
        end 
        if maxOfT==left then
           p=" left"
        end
        if maxOfT==right then
           p="right"
        end        
        value[i][j]=a[i][j]+maxOfT*0.99
        policy[i][j]=p
      end  
    end
  end  
end	

function qlearn()
  x=3
  y=2
  t=0
  for iteration=1,100 do
    local tempmax={}
    for k=1,4 do
      tempmax[k]=q[x][y][k]
    end
    local maxval=math.max(unpack(tempmax))
    local sum=0
    local dirary={}
    for k=1,4 do
    	if q[x][y][k]==maxval then
    		sum=sum+1
            dirary[sum]=k
        end
    end
    dir=dirary[math.random(sum)]        
    step(dir)
  end  

end

function step(dir)
  local tempary={}
  local fx=x
  local fy=y
  if dir==1 then     --up
    local point=q[x][y-1]
    fy=y-1
  end  
  if dir==2 then     --up
    local point=q[x][y+1]
    fy=y+1
  end  
  if dir==3 then     --up
    local point=q[x-1][y]
    fx=fx-1
  end  
  if dir==4 then     --up
    local point=q[x+1][y]
    fx=fx+1
  end  
  
  for i=1,4 do
  	tempary[i]=point[i]
  end 	
  local maxOfT = math.max(unpack(tempary))
  q[x][y][dir]=q[x][y][dir]+(60/(59+t))*(a[i][j]+0.99*maxOfT-q[x][y][dir])

  x=fx
  y=fy
  t=t+1
end
--main	
f="mp4.1input.txt"
getFile(f)
for itera=1,2000 do
	bell()
end

for i=0,5 do
  local temp = ""
  for j=0,5 do
    temp=temp..string.format("%.2f",tostring(value[i][j])).." "
  end
  print(temp)
end    
print()
for i=0,5 do
  local temp = ""
  for j=0,5 do
    temp=temp..policy[i][j].." "
  end
  print(temp)
end
print()
for i=0,5 do
  local temp = ""
  for j=0,5 do
  	max=-100
  	for k=1,4 do
  		if max<q[i][j][k] then
  			max=q[i][j][k]
  	    end
  	end    		
    temp=temp..string.format("%.2f",tostring(max)).." "
  end
  print(temp)
end  