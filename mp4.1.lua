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
  ne={}
  for i=0,5 do
  	policy[i]={}
  	ne[i]={}
    for j=0,5 do
    	ne[i][j]=0
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

function trueval(ttt)
  if ttt==2 then
  	return 0
  else
    return ttt
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

function notwall(aa,bb,d)
  fa=aa
  fb=bb
  if d==1 then     --up
    fb=bb-1
  end  
  if d==2 then     --down
    fb=bb+1
  end  
  if d==3 then     --left
    fa=aa-1
  end  
  if d==4 then     --right
    fa=aa+1
  end
  
  if fa>=0 and fa<=5 and fb>=0 and fb<=5 then
  	if a[fa][fb]~=2 then
  		return true
    else
        return false
    end
  else
    return false
  end        		

end

function qlearn()
  x=3
  y=2
  t=0
 for epi=1,300 do
  for iteration=1,6000 do
  	ne[x][y]=ne[x][y]+1
   if ne[x][y]>=20 then	
    local tempmax={}
    for k=1,4 do
      tempmax[k]=q[x][y][k]
    end
    local maxval=math.max(unpack(tempmax))
    local sum=0
    local dirary={}
    for k=1,4 do
    	if q[x][y][k]==maxval and notwall(x,y,k) then
    		sum=sum+1
            dirary[sum]=k
        end
    end
    dir=dirary[math.random(sum)]    
    print(dir)
   else
    local tempmax={}
    tempmax[1]=trueval(a[x][y-1])
    tempmax[2]=trueval(a[x][y+1])
    tempmax[3]=trueval(a[x-1][y])
    tempmax[4]=trueval(a[x+1][y])
    local maxval=math.max(unpack(tempmax))
    local sum=0
    local dirary={}
    for k=1,4 do
    	if tempmax[k]==maxval and notwall(x,y,k) then
    		sum=sum+1
            dirary[sum]=k
        end
    end

    dir=dirary[math.random(sum)]    
    print(dir)     
   end     
    step(dir)
    printq()
  end  
 end
end

function step(dir)
  local tempary={}
  local fx=x
  local fy=y
  if dir==1 then     --up
    point=q[x][y-1]
    fy=y-1
  end  
  if dir==2 then     --down
    point=q[x][y+1]
    fy=y+1
  end  
  if dir==3 then     --left
    point=q[x-1][y]
    fx=fx-1
  end  
  if dir==4 then     --right
    point=q[x+1][y]
    fx=fx+1
  end  
  
  for i=1,4 do
  	tempary[i]=point[i]
  end 	
  local maxOfT = math.max(unpack(tempary))
  q[x][y][dir]=q[x][y][dir]+(600/(599+t))*(trueval(a[x][y])+0.99*maxOfT-q[x][y][dir])

  x=fx
  y=fy
  t=t+1
end


function printq()
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

qlearn()