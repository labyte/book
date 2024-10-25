mdbook build && ./del-searcher-js.sh

# 定义变量
LOCAL_DIR="/book"
REMOTE_USER="lxj"
REMOTE_HOST="https://ign.familyds.com:5001/"
REMOTE_DIR="//volume1/web/book"

# 使用 rsync 上传文件
rsync -avz --delete "$LOCAL_DIR/" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR"

# 打印完成信息
echo "上传完成！"
