FROM httpd

#updating the system
RUN apt update -y 

#variables
ARG port=80

#creating volume
VOLUME /saves

#copy from host to the container
COPY . /saves
#Installing useful packages
RUN apt install -y unzip \
    vim 

#Container working directory
WORKDIR /usr/local/apache2/htdocs/

#Preparing the folder++
RUN rm -rf * 

#collecting the developer code
ADD   https://linux-devops-course.s3.amazonaws.com/halloween.zip .

#unzipping the directiory
RUN unzip halloween.zip && \
    cp -r halloween/* . && \
    rm -rf halloween*

#expose the container
EXPOSE ${port}