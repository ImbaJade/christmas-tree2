# 阶段 1：构建阶段
FROM node:18-alpine as builder

WORKDIR /app

# 复制依赖文件并安装 (利用缓存)
COPY package*.json ./
# 如果使用 yarn，请取消下面这行的注释并注释掉 npm install
# COPY yarn.lock ./
RUN npm install

# 复制源代码
COPY . .

# 构建项目 (Vite 默认输出到 dist 目录)
RUN npm run build

# 阶段 2：运行阶段
FROM nginx:alpine

# 复制构建产物到 Nginx 目录
COPY --from=builder /app/dist /usr/share/nginx/html

# 复制自定义 Nginx 配置 (稍后创建)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# 暴露端口
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
