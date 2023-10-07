### 累積分布関数
\( N \in \mathbb{N} \)

\( X_1, \dots, X_N \) は \([0,100]\) 上の一様分布に従う確率変数

つまり \( P(X \leq x_1, \dots, X_N \leq x_N) = P(X_1 \leq x_1) \dots P(X_N \leq x_N) = \frac{x_1}{100} \dots \frac{x_N}{100} \)

平均と標準偏差は、

\( \bar{X} \coloneqq \frac{1}{N} \sum_{k=1}^{N} X_k \quad \sigma \coloneqq \sqrt{\bar{X^2} - \bar{X}^2}\) より

標準偏差の累積分布関数は、

\( P(\sigma \leq x) = P(\bar{X^2} - \bar{X}^2 \leq x^2) \) より
\(D_x = \{ (x_1, \dots, x_N) \subseteq [0,100]^N\,| \,\frac{1}{N}\sum_{k=1}^{N} x_k^2 - \left( \frac{1}{N} \sum_{k=1}^{N} x_k \right)^2 \leq x^2 \} \)

\( X_1, \dots, X_N \) の独立性から

 \(= \int_{D_x} \left( \frac{1}{100} \right)^N dx_1 \dots dx_N \)
\(= \frac{1}{100^N} \int_{D_x} dx_1 \dots dx_N \)


\(\int_{D_x} dx_1 \dots dx_N \) を求めれば良いので

\(f(x_1, \dots, x_N)\)
\(= \frac{1}{N} \sum_{k=1}^{N} x_k^2 - \left( \frac{1}{N} \sum_{k=1}^{N} x_k \right)^2 \)
\(= \frac{1}{N^2} \left( (N-1) \sum_{k=1}^{N} x_k^2 - \sum_{i \neq j} x_i x_j \right) \)

\(= \frac{1}{N} (x_1, \dots, x_N)
\begin{pmatrix}
N-1 & -1 & \dots & -1 \\
-1 & \ddots & \ddots & \vdots \\
\vdots & \ddots & \ddots & -1 \\
-1 & \dots & -1 & N-1 \\
\end{pmatrix}
\begin{pmatrix}
x_1 \\
\vdots \\
x_N \\
\end{pmatrix}
\)となります。

\(A \coloneqq \begin{pmatrix}
N-1 & -1 & \dots & -1 \\
-1 & \ddots & \ddots & \vdots \\
\vdots & \ddots & \ddots & -1 \\
-1 & \dots & -1 & N-1 \\
\end{pmatrix}
\) とすると

\(\text{det}(\lambda E_N - A)
= \text{det}
\begin{pmatrix}
\lambda+1-N & & 1 \\
 & \ddots \\
1 & & \lambda+1-N \\
\end{pmatrix}
\)

\( \lambda \neq N-1\) なら

\(= \text{det}
\begin{pmatrix}
\; \lambda+1-N & 1 & \dots & & 1 \\
\; N-\lambda & \lambda-N & & \text{\huge{0}} &\\
\; \vdots & & \ddots & & \\
\; & \text{\huge{0}} & & \ddots & \\
\; N-\lambda & & & & \lambda-N \\
\end{pmatrix}
\)

\(= \text{det}
\begin{pmatrix}
\; \lambda & 1 & \dots & & 1 \\
\; 0 & \lambda-N & & \text{\huge{0}} &\\
\; \vdots & & \ddots & & \\
\; & \text{\huge{0}} & & \ddots & \\
\; 0 & & & & \lambda-N \\
\end{pmatrix}
\)

\( = \lambda (\lambda-N)^{N-1} \)

\( \text{det}(\lambda E_N - A) = 0 \text{ の解は } \lambda = 0, N \)

\( \text{Aはある直交行列}\,P (P P^\top = P^\top P = E_N)\,\text{を用いて対角化できるので}
\)

\( B = P^\top A P =
\begin{pmatrix}
\; N & & & \text{\huge{0}}\\
\; & \ddots & & & \\
\; & & N & &\\
\; \text{\huge{0}} & & & 0\\
\end{pmatrix}
\text{となるような} P \text{が存在します}
\)

\( \text{従って、}
\begin{pmatrix} 
y_1 \\
\vdots \\
y_N \\
\end{pmatrix}
= P^\top 
\begin{pmatrix}
x_1 \\
\vdots \\
x_N \\
\end{pmatrix}
\text{とすると}
\)

\(f(x_1, \dots, x_N) \)

\(= \frac{1}{N^2} (x_1, \dots, x_N) P (P^\top A P) P^\top 
\begin{pmatrix}
x_1 \\
\vdots \\
x_N \\
\end{pmatrix}
\)

\(
= \frac{1}{N^2}
(y_1, \dots, y_N) B
\begin{pmatrix}
y_1 \\
\vdots \\
y_N \\
\end{pmatrix}
\)

\(
= \frac{1}{N^2} (Ny_1^2 + \dots + Ny_{N-1}^2 + 0・y_N)^2
\)

\(
\mathbf{x} = P \mathbf{y} \quad \frac{\partial \mathbf{x}}{\partial \mathbf{y}} = P ,\; D'_x = \left\{ (y_1, \dots, y_N) \in P^\top([0,100]^N)\middle| \ y_1^2 + \dots + y_{N-1}^2 \leq Nx^2 \right\}
\)

\(
\int_{D_x} dx_1 \dots dx_N = \int_{D_x} |P| dy_1 \dots dy_N
\)

\(
y_N \in [a,b]\text{とする}
\)

\(
= \int_a^b \int_{y_1^2+\dots+y_{N-1}^2 \leq Nx^2} |P| dy_1 \dots dy_N 
\)

\(
= (b-a)|P|V_{N-1}(\sqrt{N}x)
\)

\[
\text{ただし、}V_{N}(r)\text{を半径rのn次元球の体積とする}
\]
