# Pythono3 code to rename multiple  
# files in a directory or folder 
  
# importing os module 
import os
import re
  
# Function to rename multiple files 
def main(): 
    for count, filename in enumerate(os.listdir("New folder (3)")):
        x=re.findall(r'\d+',filename);
        if filename=='t-'+str(x[0])+'.xml': 
            dst =str(int(x[0])+1) + ".xml"
            src ='New folder (3)\\'+ filename 
            dst ='New folder (3)\\'+ dst 
            os.rename(src, dst)
            print(src+" ---> "+dst)
        if filename=='t-'+str(x[0])+'.xml.dot': 
            dst =str(int(x[0])+1) + ".xml.dot"
            src ='New folder (3)\\'+ filename 
            dst ='New folder (3)\\'+ dst 
            os.rename(src, dst)
            print(src+" ---> "+dst)

        
  
# Driver Code 
if __name__ == '__main__': 
      
    # Calling main() function 
    main() 