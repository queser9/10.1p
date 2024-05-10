# 使用官方的Node.js 14作为基础镜像
FROM node:14

# 设置工作目录
WORKDIR /usr/src/app

# 复制package.json和package-lock.json
COPY package*.json ./

# 安装依赖
RUN npm install

# 复制所有文件到工作目录
COPY . .

# 暴露端口
EXPOSE 3000

# 启动应用
CMD ["npm", "start"]