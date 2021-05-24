FROM python:3.9.4-slim
COPY . /app
WORKDIR /app
RUN pip install -r requirements.txt
RUN chmod +x /app/entrypoint.sh
EXPOSE 5001
CMD [ "/app/entrypoint.sh" ]
