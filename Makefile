all: build

build:
	@docker build --rm=false --tag=${USER}/activiti .

test:
	build
	@docker run --name='activiti' \
	-it \
	--rm \
	-p 8080:8080 \
	-p 3000:3000 \
	${USER}/activiti

run:
	@docker run --name='activiti' \
        -d \
	-p 8080:8080 \
	-p 3000:3000 \
	${USER}/activiti

prod:
	@docker run --name='activiti' \
        -d \
	-p 8080:8080 \
	-p 3000:3000 \
	${USER}/activiti

logs:
	@docker logs -f activiti
